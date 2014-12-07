Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaLGNqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 08:46:42 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaLGNqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 08:46:39 -0500
Message-ID: <54845A3B.6020607@nod.at>
Date: Sun, 07 Dec 2014 14:46:35 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] UBI: Fastmap: Fix memory leaks while closing the
 WL sub-system
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-2-git-send-email-richard@nod.at> <54840C44.4090406@codeaurora.org> <548423E3.8010106@nod.at> <54843AE2.6070608@codeaurora.org> <54843B48.6020701@nod.at> <5484559D.8070407@codeaurora.org>
In-Reply-To: <5484559D.8070407@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.12.2014 um 14:26 schrieb Tanya Brokhman:
> you're right, found it at ubi_detach_mtd_dev() several lines after calling ubi_wl_close(). But if you're creating a fastmap-close dedicated function, fm_buf should be freed in it
> as it is fastmap related.

The idea was to have WL related stuff in this function.
But I can add more into it in a subsequent patch.

Thanks,
//richard
