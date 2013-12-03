Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3LCBxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:53:05 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11008 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3LCBxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:53:01 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-94-529d39728c63
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: "'Jonas Bonn'" <jonas@southpole.se>,
        "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
 <20131128040750.GA29917@kroah.com>
 <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
 <1385617213.12210.5.camel@joe-AO722> <20131128055328.GA565@kroah.com>
 <1385619863.12210.14.camel@joe-AO722> <529C026E.2000302@roeck-us.net>
 <000f01ceef11$a14acf00$e3e06d00$%han@samsung.com>
 <529C04C7.9050506@roeck-us.net>
 <001001ceef13$7fa3ee70$7eebcb50$%han@samsung.com>
 <1385963295.2680.2.camel@joe-AO722> <529C6495.3020305@southpole.se>
 <1386006217.2680.13.camel@joe-AO722>
In-reply-to: <1386006217.2680.13.camel@joe-AO722>
Subject: Re: [PATCH] pci/checkpatch: Deprecate DEFINE_PCI_DEVICE_TABLE
Date: Tue, 03 Dec 2013 10:52:49 +0900
Message-id: <004501ceefca$5f35b2b0$1da11810$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vhgufCLDuUZedRVGfPai4zinyVgAQ+zpg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+ZkW6R5dwgg9V/+S3mrF/DZvFhrYbF
	kqYMi+bF69ksLi+8xGox+/5jFos/Mz8wWVzeNYfN4uy842wWZxb3sls8WXiGyYHbY1ZDL5vH
	gk2lHidm/Gbx2D93DbvHl1XXmD12fm9g9+jbsorR41TPamaPz5vkAjijuGxSUnMyy1KL9O0S
	uDK+TZjJWtAqXrHskE8D4zmhLkZODgkBE4nfc5+xQdhiEhfurQeyuTiEBJYxSvw7/Q7I4QAr
	apimBlIjJDCdUWLChziIml+MEo2bv4I1swmoSXz5cpgdxBYRUJZYsOgzC0gRs8BfJokvnVeZ
	IDrmskhcf32OCaSKU8BQYvP6fWC2sICbxKElt1lAbBYBVYmN59vBpvIK2Eos+n2IBcIWlPgx
	+R6YzSygJbF+53EmCFteYvOat8wQl6pLPPqrC3GEkcTfzyegykUk9r14xwjx5UIOie1NjBCr
	BCS+TQYZD9IqK7HpADNEiaTEwRU3WCYwSsxCsngWksWzkCyehWTDAkaWVYyiqQXJBcVJ6UWG
	esWJucWleel6yfm5mxghSaB3B+PtA9aHGJOB1k9klhJNzgcmkbySeENjMyMLUxNTYyNzSzPS
	hJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYCw8J3aWpZ4tataMQvbit4uua5vO
	qdB0CGrrqSr9IZNYfMK31K37B1vVvfn7593yZ7NwNtpp01/C/e/Z/elz6//t4H5e8WGh2pFC
	81PzyoO95z66oHz24E8Tk325ZwR31bDfPNVnaN++K+J3W9YES24Nh1UFU0JbV28qSWrRulN+
	UOrfQkZbNSWW4oxEQy3mouJEAHYxV/cYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQd0iy7lBBrt7uS3mrF/DZvFhrYbF
	kqYMi+bF69ksLi+8xGox+/5jFos/Mz8wWVzeNYfN4uy842wWZxb3sls8WXiGyYHbY1ZDL5vH
	gk2lHidm/Gbx2D93DbvHl1XXmD12fm9g9+jbsorR41TPamaPz5vkAjijGhhtMlITU1KLFFLz
	kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
	YZoQGuKmawHTGKHrGxIE12NkgAYS1jFmfJswk7WgVbxi2SGfBsZzQl2MHBwSAiYSDdPUuhg5
	gUwxiQv31rOB2EIC0xklJnyI62LkArJ/MUo0bv4KlmATUJP48uUwO4gtIqAssWDRZxaQImaB
	v0wSXzqvMkF0zGWRuP76HBNIFaeAocTm9fvAbGEBN4lDS26zgNgsAqoSG8+3g03lFbCVWPT7
	EAuELSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZIa5Wl3j0VxfiCCOJv59PQJWLSOx78Y5xAqPQ
	LCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4yz6R3MK5qsDjE
	KMDBqMTD+2D7nCAh1sSy4srcQ4wSHMxKIrydPHODhHhTEiurUovy44tKc1KLDzEmAz06kVlK
	NDkfmADzSuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFx08/Z
	0/zOG71Yuf7qmewKGa4vAcFTQ6c5s1T8kvj58ZJV0mOnauU+gVPxlrIVdtqL77tnPFUNFGc2
	deK9uV9FQkX9m85sG2ObhU8+/lFN1y//Il0pWnswl2H+loIzt5+eq54z4+qaCQeSDjk/Mk9v
	u8ouONn6eKaM7rXbf4O3zW5Z07bTw9RTiaU4I9FQi7moOBEAZUHlXXYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 2:44 AM, Joe Perches
> 
> Prefer use of the direct definition of struct pci_device_id
> instead of indirection via macro DEFINE_PCI_DEVICE_TABLE.
> 
> Update the PCI documentation to deprecate DEFINE_PCI_DEVICE_TABLE.
> Update checkpatch adding --fix option.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  Documentation/PCI/pci.txt |  6 ++++--
>  include/linux/pci.h       |  3 +--
>  scripts/checkpatch.pl     | 11 +++++++----
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/PCI/pci.txt b/Documentation/PCI/pci.txt
> index 6f45856..9518006 100644
> --- a/Documentation/PCI/pci.txt
> +++ b/Documentation/PCI/pci.txt
> @@ -123,8 +123,10 @@ initialization with a pointer to a structure describing the driver
> 
> 
>  The ID table is an array of struct pci_device_id entries ending with an
> -all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
> -method of declaring the table.  Each entry consists of:
> +all-zero entry.  Definitions with static const are generally preferred.
> +Use of the deprecated macro DEFINE_PCI_DEVICE_TABLE should be avoided.
> +
> +Each entry consists of:
> 
>  	vendor,device	Vendor and device ID to match (or PCI_ANY_ID)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 1084a15..88674b0 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -634,8 +634,7 @@ struct pci_driver {
>   * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
>   * @_table: device table name
>   *
> - * This macro is used to create a struct pci_device_id array (a device table)
> - * in a generic manner.
> + * This macro is deprecated and should not be used in new code.
>   */
>  #define DEFINE_PCI_DEVICE_TABLE(_table) \
>  	const struct pci_device_id _table[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 38be5d5..6f883f0 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2643,10 +2643,13 @@ sub process {
>  			}
>  		}
> 
> -# check for declarations of struct pci_device_id
> -		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
> -			WARN("DEFINE_PCI_DEVICE_TABLE",
> -			     "Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herecurr);
> +# check for uses of DEFINE_PCI_DEVICE_TABLE
> +		if ($line =~ /\bDEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=/) {
> +			if (WARN("DEFINE_PCI_DEVICE_TABLE",
> +				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" .
> $herecurr) &&
> +			    $fix) {
> +				$fixed[$linenr - 1] =~
> s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id
> $1\[\] = /;
> +			}
>  		}
> 
>  # check for new typedefs, only function parameters and sparse annotations


