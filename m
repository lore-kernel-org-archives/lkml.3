Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaG0Onf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 10:43:35 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:32936 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaG0Ond (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 10:43:33 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 00/10] of: Core devicetree changeset support
To: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        Tyrel Datwyler <turtle.in.the.kernel@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        devicetree@vger.kernel.org
In-Reply-To: <53D29D87.4060708@austin.ibm.com>
References: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
	<53D29D87.4060708@austin.ibm.com>
Date: Sun, 27 Jul 2014 08:43:31 -0600
Message-Id: <20140727144331.73789C40603@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 13:10:15 -0500, Nathan Fontenot <nfont@austin.ibm.com> wrote:
> On 07/23/2014 06:44 PM, Grant Likely wrote:
> > Hi all,
> > 
> > This is a rollup of all the patches that I queued up today for
> > linux-next for the devicetree changeset and overlay work. I'm reposting
> > these patches because some have been significantly changed since their
> > first posting. None of the code is actually live yet, but the test cases
> > are there.
> > 
> > There is one significant functional change which may affect pseries. The
> > OF_DYNAMIC code has been changed to emit notifiers after applying a
> > change to the tree instead of before. I think I've got all they users
> > taken care of correctly, but I'd like to see some testing. I don't have
> > access to pseries (and I can't get the QEMU pseries model to boot reliably)
> > 
> > Nathan/Tyrel, can you give it a spin? The changes can be found in my git tree:
> 
> Grant,
> 
> I was able to do some sniff testing by adding/removing memory, cpus, and pci
> devices and it appears that all device tree nodes and properties were updated
> properly.
> 
> I would still like to try doing live partition migration where we can update
> many pieces of the device tree. I'll be out next week, will try to get
> on that when I return.

Thanks Nathan,

In the mean time, all this stuff is in Linux next. I would really like
to merge it for v3.17. I expect the merge window will open next weekend.
Let me know once you've been able to do the migration test. I can hold
off sending Linus a pull request until wk2 of the merge window if you
need the extra time.

g.

