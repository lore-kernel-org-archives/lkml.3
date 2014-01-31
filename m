Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbaAaTyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:54:36 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48763 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbaAaTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:54:34 -0500
Date: Fri, 31 Jan 2014 21:53:53 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: gregkh@linuxfoundation.org, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:staging:octeon-usb: Fixed Few coding style errors
Message-ID: <20140131195353.GC589@drone.musicnaut.iki.fi>
References: <1391150119-11109-1-git-send-email-surendra.tux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391150119-11109-1-git-send-email-surendra.tux@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 30, 2014 at 10:35:19PM -0800, Surendra Patil wrote:
> -	uint32_t reserved		: 25;
> -	uint32_t port_enabled		: 1;
> -	uint32_t port_over_current	: 1;
> -	uint32_t port_powered		: 1;
> -	enum cvmx_usb_speed port_speed	: 2;
> -	uint32_t connected		: 1;
> -	uint32_t connect_change		: 1;
> +	uint32_t reserved:25;
> +	uint32_t port_enabled:1;
> +	uint32_t port_over_current:1;
> +	uint32_t port_powered:1;
> +	enum cvmx_usb_speed port_speed:2;
> +	uint32_t connected:1;
> +	uint32_t connect_change:1;

Not an improvement, please don't do this.

A.
