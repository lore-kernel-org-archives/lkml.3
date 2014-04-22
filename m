Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaDVLa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:30:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:55929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152AbaDVLa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:30:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="497282714"
Date: Tue, 22 Apr 2014 14:38:27 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Resend Patch 8/9] I2C/ACPI: Move ACPI related code to i2c-acpi.c
Message-ID: <20140422113827.GL30677@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-9-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398147855-9868-9-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:24:14PM +0800, Lan Tianyu wrote:
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 681e689..fc1ef42 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -586,7 +586,10 @@ static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node
>  #ifdef CONFIG_ACPI
>  int acpi_i2c_install_space_handler(struct i2c_adapter *adapter);
>  void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter);
> +void acpi_i2c_register_devices(struct i2c_adapter *adap);
>  #else
> +static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) {};

Semicolon is not needed here.

Apart from that,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
