Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaFMEGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 00:06:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaFMEGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 00:06:35 -0400
Message-ID: <539A78C2.8080404@ti.com>
Date: Fri, 13 Jun 2014 09:36:26 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH v4 1/4] ARM: OMAP5: hwmod: Add ocp2scp3 and sata hwmods
References: <1398274237-24510-1-git-send-email-rogerq@ti.com> <1398274487-24688-1-git-send-email-rogerq@ti.com> <5399A12F.7010301@ti.com>
In-Reply-To: <5399A12F.7010301@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2014 06:16 PM, Roger Quadros wrote:
> Tony,
> 
> Looks like we've missed this for 3.16.

Without these SATA support will be broken for DRA7x and OMAP5 so can
they be queued for -rc2?

Thanks,
Sekhar
