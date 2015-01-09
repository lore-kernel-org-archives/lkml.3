Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbbAIKKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:10:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbbAIKKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:10:18 -0500
Message-ID: <1420798209.13007.8.camel@linux-0dmf.site>
Subject: Re: [PATCH v2 0/4] input: synaptics - report correct width and
 pressure values
From: Oliver Neukum <oneukum@suse.de>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, linux-kernel@vger.kernel.org,
        silverhammermba@gmail.com, peter.hutterer@who-t.net,
        hdegoede@redhat.com, benjamin.tissoires@gmail.com
Date: Fri, 09 Jan 2015 11:10:09 +0100
In-Reply-To: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
References: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 23:28 +0100, Gabriele Mazzotta wrote:
> Make image sensors and cr48 sensors report widths and fix the
> calculation of width and pressure values in some cases.
> 
> Changes since v1:
>  - Rebased on 35393dcb2ed3
>  - Get widths from AGM packets too
>  - Include support for cr48 sensors
>  - Fix pressure values on image sensors

Hi,

it seems to me that all these fixes should go into stable.

	Regards
		Oliver



