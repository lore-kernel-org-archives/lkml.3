Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaLPT4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:56:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45633 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaLPT4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:56:40 -0500
Message-ID: <54908E60.5080109@ti.com>
Date: Tue, 16 Dec 2014 13:56:16 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Lokesh Vutla <lokeshvutla@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Kristo, Tero" <t-kristo@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca> <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca> <20141214044517.GD24110@csclub.uwaterloo.ca> <549018EC.8020207@ti.com> <20141216161614.GK24110@csclub.uwaterloo.ca>
In-Reply-To: <20141216161614.GK24110@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 10:16 AM, Lennart Sorensen wrote:
> On Tue, Dec 16, 2014 at 05:05:08PM +0530, Lokesh Vutla wrote:
>> Is this applicable for OMAP5 also?
>> If not can you drop omap5 from $subject?
> 
> DRA7xx = OMAP57xx, which to me is an omap5.  Isn't it?
*AM*57xx is not *OMAP*57xx -> there is no OMAP57xx.

AM57xx and DRA7xx are in the same generation of processors and is
derivative technology (not the same) as OMAP5432/OMAP5430.

We have been using DRA7 as a generic terminology to indicate
AM57xx/DRA7 family of processors.

-- 
Regards,
Nishanth Menon
