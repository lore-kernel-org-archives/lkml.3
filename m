Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbaCTVfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:35:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44202 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaCTVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:35:20 -0400
Date: Thu, 20 Mar 2014 21:35:02 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when
 pm_power_off NULL
Message-ID: <20140320213502.795a5d3c@alan.etchedpixels.co.uk>
In-Reply-To: <20140320212336.GA17368@amd.pavel.ucw.cz>
References: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org>
	<1395348795-8554-2-git-send-email-sebastian.capella@linaro.org>
	<20140320212336.GA17368@amd.pavel.ucw.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	if (pm_power_off)
>                 pm_power_off();
> }
> 
> ## It really should do while (1) here.

	while(1)
		cpu_relax();

or similar at minimum.

Alan
