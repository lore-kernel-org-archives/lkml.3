Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbaAFRCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:02:08 -0500
Received: from atl.turmel.org ([74.117.157.138]:48728 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbaAFRCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:02:06 -0500
Message-ID: <52CAE18B.8020701@turmel.org>
Date: Mon, 06 Jan 2014 12:02:03 -0500
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andrea Mazzoleni <amadvance@gmail.com>, neilb@suse.de
CC: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
In-Reply-To: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 04:31 AM, Andrea Mazzoleni wrote:
> Hi,
> 
> This is a port to the Linux kernel of a RAID engine that I'm currently using
> in a hobby project called SnapRAID. This engine supports up to six parities
> levels and at the same time maintains compatibility with the existing Linux
> RAID6 one.

FWIW, your patch 1/2 doesn't seem to have gone through on linux-raid,
although I saw it on lkml.  Probably a different file size limit, as
that's a very large patch.

You might want to break the next submission into smaller parts.  That
might help people review it, too.

Thanks for doing this work!

Phil
