Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3EUMb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:31:27 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50149 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3EUMbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:31:25 -0400
MIME-Version: 1.0
In-Reply-To: <1368801862-24405-1-git-send-email-svgsponer@gmail.com>
References: <1368801862-24405-1-git-send-email-svgsponer@gmail.com>
Date: Tue, 21 May 2013 16:31:24 +0400
Message-ID: <CAHj3AVkExR=E9tA0zkDC5QymNrQxnYtrhwU4f-uX18HZBmM_Rw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Staging: bcm: Fix of various code style issues.
From: Denis Kirjanov <kirjanov@gmail.com>
To: Severin Gsponer <svgsponer@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin McKinney <klmckinney1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/13, Severin Gsponer <svgsponer@gmail.com> wrote:
> Changed comment style to C89 in Version.h
> Fixed some whitespace issues in Typedefs.h
> Changed comment style to C89 in vendorspecificextn.c
> All issues found with checkpatch.pl
>
> Signed-off-by: Severin Gsponer <svgsponer@gmail.com>
> ---
>  drivers/staging/bcm/Typedefs.h           |   22 ++--
>  drivers/staging/bcm/Version.h            |    8 +-
>  drivers/staging/bcm/vendorspecificextn.c |  197
> +++++++++++++++---------------
>  3 files changed, 110 insertions(+), 117 deletions(-)
>
> diff --git a/drivers/staging/bcm/Typedefs.h
> b/drivers/staging/bcm/Typedefs.h
> index a985abf..3dea509 100644
> --- a/drivers/staging/bcm/Typedefs.h
> +++ b/drivers/staging/bcm/Typedefs.h
> @@ -25,16 +25,16 @@ typedef unsigned int B_UINT32;
>  typedef unsigned long ULONG;
>  typedef unsigned long DWORD;
>
> -typedef char* PCHAR;
> -typedef short* PSHORT;
> -typedef int* PINT;
> -typedef long* PLONG;
> -typedef void* PVOID;
> -
> -typedef unsigned char* PUCHAR;
> -typedef unsigned short* PUSHORT;
> -typedef unsigned int* PUINT;
> -typedef unsigned long* PULONG;
> +typedef char *PCHAR;
> +typedef short *PSHORT;
> +typedef int *PINT;
> +typedef long *PLONG;
> +typedef void *PVOID;
> +
> +typedef unsigned char *PUCHAR;
> +typedef unsigned short *PUSHORT;
> +typedef unsigned int *PUINT;
> +typedef unsigned long *PULONG;
>  typedef unsigned long long ULONG64;
>  typedef unsigned long long LARGE_INTEGER;
>  typedef unsigned int UINT32;
> @@ -43,5 +43,5 @@ typedef unsigned int UINT32;
>  #endif

Agreed, please remove all the typedefs completely.

>
> -#endif	//__TYPEDEFS_H__
> +#endif	/* __TYPEDEFS_H__ */
>
> diff --git a/drivers/staging/bcm/Version.h b/drivers/staging/bcm/Version.h
> index a07b956..c5c5fab 100644
> --- a/drivers/staging/bcm/Version.h
> +++ b/drivers/staging/bcm/Version.h
> @@ -17,7 +17,6 @@ Abstract:
>  #define VER_FILETYPE                VFT_DRV
>  #define VER_FILESUBTYPE             VFT2_DRV_NETWORK
>
> -
>  #define VER_FILEVERSION             5.2.45
>  #define VER_FILEVERSION_STR         "5.2.45"
>
> @@ -27,9 +26,6 @@ Abstract:
>  #undef VER_PRODUCTVERSION_STR
>  #define VER_PRODUCTVERSION_STR      VER_FILEVERSION_STR
>
> +/* #include "common.ver" */

Drop the whole line here.

> -
> -
> -//#include "common.ver"
> -
> -#endif 	//VERSION_H
> +#endif /* VERSION_H */
> diff --git a/drivers/staging/bcm/vendorspecificextn.c
> b/drivers/staging/bcm/vendorspecificextn.c
> index be1f91d..29f13d7 100644
> --- a/drivers/staging/bcm/vendorspecificextn.c
> +++ b/drivers/staging/bcm/vendorspecificextn.c
> @@ -1,70 +1,70 @@
>  #include "headers.h"
> -//-----------------------------------------------------------------------------
> -// Procedure:	vendorextnGetSectionInfo
> -//
> -// Description: Finds the type of NVM used.
> -//
> -// Arguments:
> -//		Adapter    - ptr to Adapter object instance
> -//		pNVMType   - ptr to NVM type.
> -// Returns:
> -//		STATUS_SUCCESS/STATUS_FAILURE
> -//
> -//-----------------------------------------------------------------------------
> +/*
> + * Procedure:	vendorextnGetSectionInfo
> + *
> + * Description: Finds the type of NVM used.
> + *
> + * Arguments:
> + *		Adapter    - ptr to Adapter object instance
> + *		pNVMType   - ptr to NVM type.
> + * Returns:
> + *		STATUS_SUCCESS/STATUS_FAILURE
> + *
> + */
>  INT vendorextnGetSectionInfo(PVOID  pContext, struct
> bcm_flash2x_vendor_info *pVendorInfo)
>  {
>  	return STATUS_FAILURE;
>  }
>
> -//-----------------------------------------------------------------------------
> -// Procedure:   vendorextnInit
> -//
> -// Description: Initializing the vendor extension NVM interface
> -//
> -// Arguments:
> -//              Adapter   - Pointer to MINI Adapter Structure.
> -
> -// Returns:
> -//              STATUS_SUCCESS/STATUS_FAILURE
> -//
> -//-----------------------------------------------------------------------------
> +/*
> + * Procedure:   vendorextnInit
> + *
> + * Description: Initializing the vendor extension NVM interface
> + *
> + * Arguments:
> + *              Adapter   - Pointer to MINI Adapter Structure
> + * Returns:
> + *             STATUS_SUCCESS/STATUS_FAILURE
> + *
> + *
> + */
>  INT vendorextnInit(struct bcm_mini_adapter *Adapter)
>  {
>  	return STATUS_SUCCESS;
>  }
>
> -//-----------------------------------------------------------------------------
> -// Procedure:   vendorextnExit
> -//
> -// Description: Free the resource associated with vendor extension NVM
> interface
> -//
> -// Arguments:
> -//              Adapter   - Pointer to MINI Adapter Structure.
> -
> -// Returns:
> -//              STATUS_SUCCESS/STATUS_FAILURE
> -//
> -//-----------------------------------------------------------------------------
> +/*
> + * Procedure:   vendorextnExit
> + *
> + * Description: Free the resource associated with vendor extension NVM
> interface
> + *
> + * Arguments:
> + *
> + * Returns:
> + *              STATUS_SUCCESS/STATUS_FAILURE
> + *
> + *
> + */
>  INT vendorextnExit(struct bcm_mini_adapter *Adapter)
>  {
>  	return STATUS_SUCCESS;
>  }
>
> -//------------------------------------------------------------------------
> -// Procedure:	vendorextnIoctl
> -//
> -// Description: 	execute the vendor extension specific ioctl
> -//
> -//Arguments:
> -//		Adapter -Beceem private Adapter Structure
> -//		cmd 	-vendor extension specific Ioctl commad
> -//		arg		-input parameter sent by vendor
> -//
> -// Returns:
> -//		CONTINUE_COMMON_PATH in case it is not meant to be processed by vendor
> ioctls
> -//		STATUS_SUCCESS/STATUS_FAILURE as per the IOCTL return value
> -//
> -//--------------------------------------------------------------------------
> +/*
> + * Procedure:	vendorextnIoctl
> + *
> + * Description: execute the vendor extension specific ioctl
> + *
> + * Arguments:
> + *		Adapter -Beceem private Adapter Structure
> + *		cmd	-vendor extension specific Ioctl commad
> + *		arg	-input parameter sent by vendor
> + *
> + * Returns:
> + *		CONTINUE_COMMON_PATH in case it is not meant to be processed by vendor
> ioctls
> + *		STATUS_SUCCESS/STATUS_FAILURE as per the IOCTL return value
> + */
> +
>  INT vendorextnIoctl(struct bcm_mini_adapter *Adapter, UINT cmd, ULONG arg)
>  {
>  	return CONTINUE_COMMON_PATH;
> @@ -72,22 +72,21 @@ INT vendorextnIoctl(struct bcm_mini_adapter *Adapter,
> UINT cmd, ULONG arg)
>
>
>
> -//------------------------------------------------------------------
> -// Procedure:	vendorextnReadSection
> -//
> -// Description: Reads from a section of NVM
> -//
> -// Arguments:
> -//		pContext - ptr to Adapter object instance
> -//		pBuffer - Read the data from Vendor Area to this buffer
> -//		SectionVal   - Value of type of Section
> -//		Offset - Read from the Offset of the Vendor Section.
> -//		numOfBytes - Read numOfBytes from the Vendor section to Buffer
> -//
> -// Returns:
> -//		STATUS_SUCCESS/STATUS_FAILURE
> -//
> -//------------------------------------------------------------------
> +/*
> + * Procedure:	vendorextnReadSection
> + *
> + * Description: Reads from a section of NVM
> + *
> + * Arguments:
> + *		pContext - ptr to Adapter object instance
> + *		pBuffer - Read the data from Vendor Area to this buffer
> + *		SectionVal   - Value of type of Section
> + *		Offset - Read from the Offset of the Vendor Section.
> + *		numOfBytes - Read numOfBytes from the Vendor section to Buffer
> + *
> + * Returns:
> + *		STATUS_SUCCESS/STATUS_FAILURE
> + */
>
>  INT vendorextnReadSection(PVOID  pContext, PUCHAR pBuffer, enum
> bcm_flash2x_section_val SectionVal,
>  			UINT offset, UINT numOfBytes)
> @@ -97,23 +96,22 @@ INT vendorextnReadSection(PVOID  pContext, PUCHAR
> pBuffer, enum bcm_flash2x_sect
>
>
>
> -//------------------------------------------------------------------
> -// Procedure:	vendorextnWriteSection
> -//
> -// Description: Write to a Section of NVM
> -//
> -// Arguments:
> -//		pContext - ptr to Adapter object instance
> -//		pBuffer - Write the data provided in the buffer
> -//		SectionVal   - Value of type of Section
> -//		Offset - Writes to the Offset of the Vendor Section.
> -//		numOfBytes - Write num Bytes after reading from pBuffer.
> -//		bVerify - the Buffer Written should be verified.
> -//
> -// Returns:
> -//		STATUS_SUCCESS/STATUS_FAILURE
> -//
> -//------------------------------------------------------------------
> +/*
> + * Procedure:	vendorextnWriteSection
> + *
> + * Description: Write to a Section of NVM
> + *
> + * Arguments:
> + *		pContext - ptr to Adapter object instance
> + *		pBuffer - Write the data provided in the buffer
> + *		SectionVal   - Value of type of Section
> + *		Offset - Writes to the Offset of the Vendor Section.
> + *		numOfBytes - Write num Bytes after reading from pBuffer.
> + *		bVerify - the Buffer Written should be verified.
> + *
> + * Returns:
> + *		STATUS_SUCCESS/STATUS_FAILURE
> + */
>  INT vendorextnWriteSection(PVOID  pContext, PUCHAR pBuffer, enum
> bcm_flash2x_section_val SectionVal,
>  			UINT offset, UINT numOfBytes, BOOLEAN bVerify)
>  {
> @@ -122,22 +120,21 @@ INT vendorextnWriteSection(PVOID  pContext, PUCHAR
> pBuffer, enum bcm_flash2x_sec
>
>
>
> -//------------------------------------------------------------------
> -// Procedure:	vendorextnWriteSectionWithoutErase
> -//
> -// Description: Write to a Section of NVM without erasing the sector
> -//
> -// Arguments:
> -//		pContext - ptr to Adapter object instance
> -//		pBuffer - Write the data provided in the buffer
> -//		SectionVal   - Value of type of Section
> -//		Offset - Writes to the Offset of the Vendor Section.
> -//		numOfBytes - Write num Bytes after reading from pBuffer.
> -//
> -// Returns:
> -//		STATUS_SUCCESS/STATUS_FAILURE
> -//
> -//------------------------------------------------------------------
> +/*
> + * Procedure:	vendorextnWriteSectionWithoutErase
> + *
> + * Description: Write to a Section of NVM without erasing the sector
> + *
> + * Arguments:
> + *		pContext - ptr to Adapter object instance
> + *		pBuffer - Write the data provided in the buffer
> + *		SectionVal   - Value of type of Section
> + *		Offset - Writes to the Offset of the Vendor Section.
> + *		numOfBytes - Write num Bytes after reading from pBuffer.
> + *
> + * Returns:
> + *		STATUS_SUCCESS/STATUS_FAILURE
> + */
>  INT vendorextnWriteSectionWithoutErase(PVOID  pContext, PUCHAR pBuffer,
> enum bcm_flash2x_section_val SectionVal,
>  			UINT offset, UINT numOfBytes)
>  {
> --
> 1.7.10.4
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>


-- 
Regards,
Denis
