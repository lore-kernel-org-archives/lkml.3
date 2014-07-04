Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaGDKb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:31:27 -0400
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:41920 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751198AbaGDKbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:31:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:1:2:41:69:355:379:541:599:800:960:967:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:2194:2199:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3657:3770:3865:3866:3867:3868:3870:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4052:4250:4321:4605:5007:6117:7652:7974:8599:9010:9025:9121:9388:10004:10848:11026:11232:11233:11253:11473:11658:11854:11914:12043:12214:12291:12296:12438:12517:12519:12555:12683:12740:12776:13019:13138:13231:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,Doma
X-HE-Tag: dirt39_80643c809634b
X-Filterd-Recvd-Size: 10866
Message-ID: <1404469880.6384.11.camel@joe-AO725>
Subject: Re: [PATCH] ACPICA: amlresrc.h: Neaten AML_<FOO> definitions and
 uses
From: Joe Perches <joe@perches.com>
To: Robert Moore <robert.moore@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 04 Jul 2014 03:31:20 -0700
In-Reply-To: <1399677947.2912.41.camel@joe-AO725>
References: <1399677947.2912.41.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Fri, 2014-05-09 at 16:25 -0700, Joe Perches wrote:
> Use a more normal style for these slightly odd #defines.
> 
> Remove trailing semicolons from #defines
> Add semicolon to uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> I think these are unnecessarily obfuscating and the #defines
> should be expanded in-place instead.
> 
>  drivers/acpi/acpica/amlresrc.h | 137 +++++++++++++++++++++++++----------------
>  1 file changed, 84 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/amlresrc.h b/drivers/acpi/acpica/amlresrc.h
> index f3f8344..fb1a1b5 100644
> --- a/drivers/acpi/acpica/amlresrc.h
> +++ b/drivers/acpi/acpica/amlresrc.h
> @@ -133,38 +133,46 @@ struct asl_resource_node {
>  /*
>   * SMALL descriptors
>   */
> -#define AML_RESOURCE_SMALL_HEADER_COMMON \
> -	u8                              descriptor_type;
> +#define AML_RESOURCE_SMALL_HEADER_COMMON	\
> +	u8 descriptor_type
>  
>  struct aml_resource_small_header {
> -AML_RESOURCE_SMALL_HEADER_COMMON};
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +};
>  
>  struct aml_resource_irq {
> -	AML_RESOURCE_SMALL_HEADER_COMMON u16 irq_mask;
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +	u16 irq_mask;
>  	u8 flags;
>  };
>  
>  struct aml_resource_irq_noflags {
> -	AML_RESOURCE_SMALL_HEADER_COMMON u16 irq_mask;
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +	u16 irq_mask;
>  };
>  
>  struct aml_resource_dma {
> -	AML_RESOURCE_SMALL_HEADER_COMMON u8 dma_channel_mask;
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +	u8 dma_channel_mask;
>  	u8 flags;
>  };
>  
>  struct aml_resource_start_dependent {
> -	AML_RESOURCE_SMALL_HEADER_COMMON u8 flags;
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +	u8 flags;
>  };
>  
>  struct aml_resource_start_dependent_noprio {
> -AML_RESOURCE_SMALL_HEADER_COMMON};
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +};
>  
>  struct aml_resource_end_dependent {
> -AML_RESOURCE_SMALL_HEADER_COMMON};
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +};
>  
>  struct aml_resource_io {
> -	AML_RESOURCE_SMALL_HEADER_COMMON u8 flags;
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +	u8 flags;
>  	u16 minimum;
>  	u16 maximum;
>  	u8 alignment;
> @@ -172,19 +180,23 @@ struct aml_resource_io {
>  };
>  
>  struct aml_resource_fixed_io {
> -	AML_RESOURCE_SMALL_HEADER_COMMON u16 address;
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +	u16 address;
>  	u8 address_length;
>  };
>  
>  struct aml_resource_vendor_small {
> -AML_RESOURCE_SMALL_HEADER_COMMON};
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +};
>  
>  struct aml_resource_end_tag {
> -	AML_RESOURCE_SMALL_HEADER_COMMON u8 checksum;
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +	u8 checksum;
>  };
>  
>  struct aml_resource_fixed_dma {
> -	AML_RESOURCE_SMALL_HEADER_COMMON u16 request_lines;
> +	AML_RESOURCE_SMALL_HEADER_COMMON;
> +	u16 request_lines;
>  	u16 channels;
>  	u8 width;
>  };
> @@ -192,12 +204,13 @@ struct aml_resource_fixed_dma {
>  /*
>   * LARGE descriptors
>   */
> -#define AML_RESOURCE_LARGE_HEADER_COMMON \
> -	u8                              descriptor_type;\
> -	u16                             resource_length;
> +#define AML_RESOURCE_LARGE_HEADER_COMMON			\
> +	u8 descriptor_type;					\
> +	u16 resource_length
>  
>  struct aml_resource_large_header {
> -AML_RESOURCE_LARGE_HEADER_COMMON};
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +};
>  
>  /* General Flags for address space resource descriptors */
>  
> @@ -206,7 +219,8 @@ AML_RESOURCE_LARGE_HEADER_COMMON};
>  #define ACPI_RESOURCE_FLAG_MAF      8
>  
>  struct aml_resource_memory24 {
> -	AML_RESOURCE_LARGE_HEADER_COMMON u8 flags;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	u8 flags;
>  	u16 minimum;
>  	u16 maximum;
>  	u16 alignment;
> @@ -214,10 +228,12 @@ struct aml_resource_memory24 {
>  };
>  
>  struct aml_resource_vendor_large {
> -AML_RESOURCE_LARGE_HEADER_COMMON};
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +};
>  
>  struct aml_resource_memory32 {
> -	AML_RESOURCE_LARGE_HEADER_COMMON u8 flags;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	u8 flags;
>  	u32 minimum;
>  	u32 maximum;
>  	u32 alignment;
> @@ -225,22 +241,26 @@ struct aml_resource_memory32 {
>  };
>  
>  struct aml_resource_fixed_memory32 {
> -	AML_RESOURCE_LARGE_HEADER_COMMON u8 flags;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	u8 flags;
>  	u32 address;
>  	u32 address_length;
>  };
>  
> -#define AML_RESOURCE_ADDRESS_COMMON \
> -	u8                              resource_type; \
> -	u8                              flags; \
> -	u8                              specific_flags;
> +#define AML_RESOURCE_ADDRESS_COMMON			\
> +	u8 resource_type;				\
> +	u8 flags;					\
> +	u8 specific_flags
>  
>  struct aml_resource_address {
> -AML_RESOURCE_LARGE_HEADER_COMMON AML_RESOURCE_ADDRESS_COMMON};
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_ADDRESS_COMMON;
> +};
>  
>  struct aml_resource_extended_address64 {
> -	AML_RESOURCE_LARGE_HEADER_COMMON
> -	    AML_RESOURCE_ADDRESS_COMMON u8 revision_ID;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_ADDRESS_COMMON;
> +	u8 revision_ID;
>  	u8 reserved;
>  	u64 granularity;
>  	u64 minimum;
> @@ -253,8 +273,9 @@ struct aml_resource_extended_address64 {
>  #define AML_RESOURCE_EXTENDED_ADDRESS_REVISION          1	/* ACPI 3.0 */
>  
>  struct aml_resource_address64 {
> -	AML_RESOURCE_LARGE_HEADER_COMMON
> -	    AML_RESOURCE_ADDRESS_COMMON u64 granularity;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_ADDRESS_COMMON;
> +	u64 granularity;
>  	u64 minimum;
>  	u64 maximum;
>  	u64 translation_offset;
> @@ -262,8 +283,9 @@ struct aml_resource_address64 {
>  };
>  
>  struct aml_resource_address32 {
> -	AML_RESOURCE_LARGE_HEADER_COMMON
> -	    AML_RESOURCE_ADDRESS_COMMON u32 granularity;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_ADDRESS_COMMON;
> +	u32 granularity;
>  	u32 minimum;
>  	u32 maximum;
>  	u32 translation_offset;
> @@ -271,8 +293,9 @@ struct aml_resource_address32 {
>  };
>  
>  struct aml_resource_address16 {
> -	AML_RESOURCE_LARGE_HEADER_COMMON
> -	    AML_RESOURCE_ADDRESS_COMMON u16 granularity;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_ADDRESS_COMMON;
> +	u16 granularity;
>  	u16 minimum;
>  	u16 maximum;
>  	u16 translation_offset;
> @@ -280,14 +303,16 @@ struct aml_resource_address16 {
>  };
>  
>  struct aml_resource_extended_irq {
> -	AML_RESOURCE_LARGE_HEADER_COMMON u8 flags;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	u8 flags;
>  	u8 interrupt_count;
>  	u32 interrupts[1];
>  	/* res_source_index, res_source optional fields follow */
>  };
>  
>  struct aml_resource_generic_register {
> -	AML_RESOURCE_LARGE_HEADER_COMMON u8 address_space_id;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	u8 address_space_id;
>  	u8 bit_width;
>  	u8 bit_offset;
>  	u8 access_size;		/* ACPI 3.0, was previously Reserved */
> @@ -297,7 +322,8 @@ struct aml_resource_generic_register {
>  /* Common descriptor for gpio_int and gpio_io (ACPI 5.0) */
>  
>  struct aml_resource_gpio {
> -	AML_RESOURCE_LARGE_HEADER_COMMON u8 revision_id;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	u8 revision_id;
>  	u8 connection_type;
>  	u16 flags;
>  	u16 int_flags;
> @@ -327,14 +353,14 @@ struct aml_resource_gpio {
>  
>  /* Common preamble for all serial descriptors (ACPI 5.0) */
>  
> -#define AML_RESOURCE_SERIAL_COMMON \
> -	u8                              revision_id; \
> -	u8                              res_source_index; \
> -	u8                              type; \
> -	u8                              flags; \
> -	u16                             type_specific_flags; \
> -	u8                              type_revision_id; \
> -	u16                             type_data_length; \
> +#define AML_RESOURCE_SERIAL_COMMON				\
> +	u8 revision_id;						\
> +	u8 res_source_index;					\
> +	u8 type;						\
> +	u8 flags;						\
> +	u16 type_specific_flags;				\
> +	u8 type_revision_id;					\
> +	u16 type_data_length
>  
>  /* Values for the type field above */
>  
> @@ -345,11 +371,14 @@ struct aml_resource_gpio {
>  #define AML_RESOURCE_VENDOR_SERIALBUSTYPE       192	/* Vendor defined is 0xC0-0xFF (NOT SUPPORTED) */
>  
>  struct aml_resource_common_serialbus {
> -AML_RESOURCE_LARGE_HEADER_COMMON AML_RESOURCE_SERIAL_COMMON};
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_SERIAL_COMMON;
> +};
>  
>  struct aml_resource_i2c_serialbus {
> -	AML_RESOURCE_LARGE_HEADER_COMMON
> -	    AML_RESOURCE_SERIAL_COMMON u32 connection_speed;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_SERIAL_COMMON;
> +	u32 connection_speed;
>  	u16 slave_address;
>  	/*
>  	 * Optional fields follow immediately:
> @@ -363,8 +392,9 @@ struct aml_resource_i2c_serialbus {
>  #define AML_RESOURCE_I2C_MIN_DATA_LEN           6
>  
>  struct aml_resource_spi_serialbus {
> -	AML_RESOURCE_LARGE_HEADER_COMMON
> -	    AML_RESOURCE_SERIAL_COMMON u32 connection_speed;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_SERIAL_COMMON;
> +	u32 connection_speed;
>  	u8 data_bit_length;
>  	u8 clock_phase;
>  	u8 clock_polarity;
> @@ -381,8 +411,9 @@ struct aml_resource_spi_serialbus {
>  #define AML_RESOURCE_SPI_MIN_DATA_LEN           9
>  
>  struct aml_resource_uart_serialbus {
> -	AML_RESOURCE_LARGE_HEADER_COMMON
> -	    AML_RESOURCE_SERIAL_COMMON u32 default_baud_rate;
> +	AML_RESOURCE_LARGE_HEADER_COMMON;
> +	AML_RESOURCE_SERIAL_COMMON;
> +	u32 default_baud_rate;
>  	u16 rx_fifo_size;
>  	u16 tx_fifo_size;
>  	u8 parity;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



