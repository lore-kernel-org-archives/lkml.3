Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbbAFRJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:09:18 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49337 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbAFRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:09:16 -0500
Message-ID: <54AC16E8.6060304@wwwdotorg.org>
Date: Tue, 06 Jan 2015 10:10:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, linux-tegra@vger.kernel.org
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: tegra: Move out nyan-generic parts out from
 the nyan-big DT
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com> <1420540653-14816-3-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1420540653-14816-3-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 03:37 AM, Tomeu Vizoso wrote:
> In preparation for adding the DT for the nyan-blaze board.

"git format-patch -M" and/or "git format-patch -C" should make this 
patch a lot easier to review, since it'll show the patch as a file 
copy/rename rather than a full-file cut/paste.
