Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3J1GRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:17:37 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46390 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3J1GRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:17:35 -0400
Date: Sun, 27 Oct 2013 23:17:31 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] power_supply: Introduce PSE compliant algorithm
Message-ID: <20131028061731.GA32066@teo>
References: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
 <1379959445-28207-8-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1379959445-28207-8-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 11:34:05PM +0530, Jenny TC wrote:
[...]
> +#define BATTID_STR_LEN		8
> +#define BATT_TEMP_NR_RNG	6
> +/* Charging Profile */
> +struct psy_ps_pse_mod_prof {
> +	/* battery id */
> +	char batt_id[BATTID_STR_LEN];
> +	/* type of battery */
> +	u16 battery_type;
> +	u16 capacity;
> +	u16 voltage_max;
> +	/* charge termination current */
> +	u16 chrg_term_mA;
> +	/* Low battery level voltage */
> +	u16 low_batt_mV;
> +	/* upper and lower temperature limits on discharging */
> +	u8 disch_tmp_ul;
> +	u8 disch_tmp_ll;
> +	/* number of temperature monitoring ranges */
> +	u16 temp_mon_ranges;
> +	struct psy_ps_temp_chg_table temp_mon_range[BATT_TEMP_NR_RNG];
> +	/* Lowest temperature supported */
> +	short int temp_low_lim;
> +} __packed;

These all seem like properties of a battery. Why the battery is not
registered with the power_supply framework?

What is PSE, by the way?

Anton
