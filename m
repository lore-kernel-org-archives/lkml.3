Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3COA5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:57:07 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:55820 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3COA5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:57:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAEsagEipOf7V2w0oojQLw0jMp4LL2o7cKRHsLncAJER0yLWbqg@mail.gmail.com>
References: <CAEsagEipOf7V2w0oojQLw0jMp4LL2o7cKRHsLncAJER0yLWbqg@mail.gmail.com>
Date: Thu, 14 Mar 2013 17:57:01 -0700
Message-ID: <CAEsagEjTs2=JLmeHGDW558VdXNtu17WusFp+2Zv7RiJmw2C+kA@mail.gmail.com>
Subject: Re: Tux3 Report: Birds of a Feather flocked Together
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: linux-kernel@vger.kernel.org, tux3@tux3.org
Cc: linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's Tux3 report is a little shorter than usual, not because there
is less to report but because we are very busy preparing for the next
Tux3 report, expected to be long and hopefully interesting.

The first annual Tux3 BOF at FAST was held month in San Jose. Here is
the group photo:

      http://phunq.net/files/tux3.bof.fast.2013.jpg

Some of the usual suspects may be easily recognized.[1] Hirofumi
attended remotely from Tokyo via an audio link kindly provided by
Shapor (on the left).

Though no notes were kept, the gist of the meeting can be summed up easily:

   1) Purpose: What niche does Tux3 expect to fill?

   2) Progress: What works now and what remains to be done?

   3) Time frame: How many person-years of development work remain?

Purpose: With its compact footprint and even more compact feature set,
we agree that the natural niches for Tux3 are personal workstations
and portable devices. While Tux3 is designed to scale to enterprise
levels, such scalability has not yet been proven, some features
required for enterprise deployment are not yet available, and a record
of reliability has not yet been established. Therefore, the enterprise
segment would be better served for the time being by such established
projects as Ext4. This is not a serious issue given that the personal
workstation and portable device segment already amounts to some
hundreds of millions of potential users.

Progress: Tux3 has come far enough that there now can be no turning
back. According to our initial measurements, we expect to raise the
bar in terms of performance while at the same time introducing a
stronger filesystem consistency model. The list of outstanding work
items to bring Tux3 to a state suitable for testing by early adopters
is quite short.

Timeframe: The question was raised of how many man years of
development would be needed to bring Tux3 to a usable state. I
suggested eight, which was immediately questioned on the basis that
Ext4 and its predecessors easily account for several hundred man years
of development. My answer was accordingly clarified to be the number
of years that our small team can reasonably afford to dedicate to the
project in order to bring it to the point where further manpower
accretion tends to become exponential. This hockey stick effect is a
necessary event in the lifetime of any filesystem project that will
actually be deployed. It was generally thought that merging the code
base would help bring that moment closer.

Beer: The beer, provided by tux3.org, was excellent. Several instances
may be observed actively deployed in the photo. Next year, we hope and
expect that our beer will be kindly provided for us by some wealthier
organization.

So long for now. Next week I will report in some detail on our recent
efforts to develop a next-generation directory index for Tux3.

[1] The gentleman operating the camera itself did not wish to be
recognized at this time.

Regards,

Daniel
