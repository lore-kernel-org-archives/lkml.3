Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3EaUCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:02:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47457 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab3EaUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:02:14 -0400
Message-ID: <51A9018A.7030700@infradead.org>
Date: Fri, 31 May 2013 13:01:14 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/v2] [trivial] treewide: Fix typo in printk
References: <1369925065-16604-1-git-send-email-standby24x7@gmail.com> <1370017856-32266-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1370017856-32266-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/13 09:30, Masanari Iida wrote:
> Correct spelling typo in printk within various drivers.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> 
> ---
>  drivers/acpi/acpica/utobject.c                 | 2 +-
>  drivers/cpufreq/s3c2416-cpufreq.c              | 2 +-
>  drivers/net/ethernet/mellanox/mlx4/main.c      | 2 +-
>  drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
>  drivers/net/wireless/ath/ath9k/Kconfig         | 2 +-
>  drivers/scsi/libiscsi_tcp.c                    | 2 +-
>  drivers/scsi/pmcraid.c                         | 2 +-
>  lib/Kconfig.kgdb                               | 4 ++--
>  8 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/utobject.c b/drivers/acpi/acpica/utobject.c
> index 1099f5c..61a113c 100644
> --- a/drivers/acpi/acpica/utobject.c
> +++ b/drivers/acpi/acpica/utobject.c
> @@ -354,7 +354,7 @@ u8 acpi_ut_valid_internal_object(void *object)
>  
>  	default:
>  		ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
> -				  "%p is not not an ACPI operand obj [%s]\n",
> +				  "%p is not an ACPI operand obj [%s]\n",
>  				  object, acpi_ut_get_descriptor_name(object)));
>  		break;
>  	}
> diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
> index 4f1881e..e594c62 100644
> --- a/drivers/cpufreq/s3c2416-cpufreq.c
> +++ b/drivers/cpufreq/s3c2416-cpufreq.c
> @@ -205,7 +205,7 @@ static int s3c2416_cpufreq_leave_dvs(struct s3c2416_data *s3c_freq, int idx)
>  		ret = s3c2416_cpufreq_set_armdiv(s3c_freq,
>  					clk_get_rate(s3c_freq->hclk) / 1000);
>  		if (ret < 0) {
> -			pr_err("cpufreq: Failed to to set the armdiv to %lukHz: %d\n",
> +			pr_err("cpufreq: Failed to set the armdiv to %lukHz: %d\n",
>  			       clk_get_rate(s3c_freq->hclk) / 1000, ret);
>  			return ret;
>  		}
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 0d32a82..c8595ec 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -98,7 +98,7 @@ MODULE_PARM_DESC(log_num_mgm_entry_size, "log mgm size, that defines the num"
>  static bool enable_64b_cqe_eqe;
>  module_param(enable_64b_cqe_eqe, bool, 0444);
>  MODULE_PARM_DESC(enable_64b_cqe_eqe,
> -		 "Enable 64 byte CQEs/EQEs when the the FW supports this");
> +		 "Enable 64 byte CQEs/EQEs when the FW supports this");
>  
>  #define HCA_GLOBAL_CAP_MASK            0
>  
> diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
> index cbfaed5..5a20eaf 100644
> --- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
> +++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
> @@ -3444,7 +3444,7 @@ static int vxge_device_register(struct __vxge_hw_device *hldev,
>  	}
>  
>  	vxge_debug_init(vxge_hw_device_trace_level_get(hldev),
> -		"%s : checksuming enabled", __func__);
> +		"%s : checksumming enabled", __func__);
>  
>  	if (high_dma) {
>  		ndev->features |= NETIF_F_HIGHDMA;
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
> index 3b07851..b8fe237 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -28,7 +28,7 @@ config ATH9K
>  	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
>  	  of chipsets. For a specific list of supported external
>  	  cards, laptops that already ship with these cards and
> -	  APs that come with these cards refer to to ath9k wiki
> +	  APs that come with these cards refer to ath9k wiki
>  	  products page:
>  
>  	  http://wireless.kernel.org/en/users/Drivers/ath9k/products
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 552e8a2..92deec5 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -558,7 +558,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>  	if (!rc) {
>  		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
>  				  "Target has sent more R2Ts than it "
> -				  "negotiated for or driver has has leaked.\n");
> +				  "negotiated for or driver has leaked.\n");
>  		return ISCSI_ERR_PROTO;
>  	}
>  
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 8e1b737..1eb7b028 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -6092,7 +6092,7 @@ static int __init pmcraid_init(void)
>  
>  	if (IS_ERR(pmcraid_class)) {
>  		error = PTR_ERR(pmcraid_class);
> -		pmcraid_err("failed to register with with sysfs, error = %x\n",
> +		pmcraid_err("failed to register with sysfs, error = %x\n",
>  			    error);
>  		goto out_unreg_chrdev;
>  	}
> diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
> index 140e878..358eb81 100644
> --- a/lib/Kconfig.kgdb
> +++ b/lib/Kconfig.kgdb
> @@ -64,8 +64,8 @@ config KGDB_LOW_LEVEL_TRAP
>         default n
>         help
>           This will add an extra call back to kgdb for the breakpoint
> -         exception handler on which will will allow kgdb to step
> -         through a notify handler.
> +         exception handler which will allow kgdb to step through a
> +         notify handler.
>  
>  config KGDB_KDB
>  	bool "KGDB_KDB: include kdb frontend for kgdb"
> 


-- 
~Randy
