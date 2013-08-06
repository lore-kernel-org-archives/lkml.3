Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3HFOCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:02:30 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46250 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3HFOC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:02:28 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1375797260.8219.21.camel@jlt4.sipsolutions.net>
References: <CA+icZUX8OcTSOABO6Nbz5R6_5-m39rsYOpDqYBA7hf8LFvJLLA@mail.gmail.com>
	<1375797260.8219.21.camel@jlt4.sipsolutions.net>
Date: Tue, 6 Aug 2013 16:02:27 +0200
Message-ID: <CA+icZUWuLWY9w8wAP1SU9A7ibrbM=fMDN58DS7BQO6Xg66_A0w@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 6 [ wireless | iwlwifi | mac80211 ? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 3:54 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-08-06 at 15:51 +0200, Sedat Dilek wrote:
>> OK, I did not try with debugging enabled and/or w/o Network-Manager.
>>
>> If you know of an issue, please let me know.
>
> No, but the dmesg looks like security problems - check wpa_supplicant
> log
>

Which line is this?

This one:

[   27.992248] wlan0: deauthenticated from 00:04:0e:e4:00:3d (Reason: 1)

- Sedat -

> johannes
>
