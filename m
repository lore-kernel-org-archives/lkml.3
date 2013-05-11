Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3EKSfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 14:35:47 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37830 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3EKSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 14:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com>
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
	<20130510045049.GU24635@dastard>
	<CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com>
Date: Sat, 11 May 2013 11:35:45 -0700
Message-ID: <CAPkEcwi7J8U_pUKCVBwrpLVauddokTytcq=PUqSSkUELdUiatg@mail.gmail.com>
Subject: Re: Tux3 Report: Faster than tmpfs, what?
From: james northrup <northrup.james@gmail.com>
To: Daniel Phillips <daniel.raymond.phillips@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        tux3@tux3.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also interesting information... Study of 2,047 papers on PubMed finds
that two-thirds of retracted papers were down to scientific
misconduct, not error

On Fri, May 10, 2013 at 11:12 PM, Daniel Phillips
<daniel.raymond.phillips@gmail.com> wrote:
> Hi Dave,
>
> Thanks for the catch - I should indeed have noted that "modified
> dbench" was used for this benchmark, thus amplifying Tux3's advantage
> in delete performance. This literary oversight does not make the
> results any less interesting: we beat Tmpfs on that particular load.
> Beating tmpfs at anything is worthy of note. Obviously, all three
