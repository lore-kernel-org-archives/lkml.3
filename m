Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab3FMOBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:01:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab3FMOBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:01:21 -0400
Message-ID: <51B9D0AD.1060505@suse.cz>
Date: Thu, 13 Jun 2013 16:01:17 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, trivial@kernel.org
Subject: Re: [PATCH RESEND] Makefile.lib: align DTB quiet_cmd
References: <1371120789-18342-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1371120789-18342-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.6.2013 12:53, James Hogan wrote:
> The unaligned dtb.S filename in make output started to irritate me:
>   DTC     arch/metag/boot/dts/skeleton.dtb
>   DTB    arch/metag/boot/dts/skeleton.dtb.S
>   AS      arch/metag/boot/dts/skeleton.dtb.o
>   LD      arch/metag/boot/dts/built-in.o
> 
> Add an extra space to quiet_cmd_dt_S_dtb so the dtb.S filename aligns
> with all the others.

Applied to kbuild.git#kbuild.

Michal
