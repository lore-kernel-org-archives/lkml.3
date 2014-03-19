Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaCSUJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:09:18 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:48482 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaCSUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140318214909.GA12807@srcf.ucam.org>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
	<20140318214909.GA12807@srcf.ucam.org>
Date: Wed, 19 Mar 2014 22:09:15 +0200
Message-ID: <CACV2jQBg5aRh0FiWpxneUitr7gE2n-_sNafeWE__iT490dzBZQ@mail.gmail.com>
Subject: Re: [RFC] QR encoding for Oops messages
From: =?ISO-8859-2?B?VGVvZG9yYSBC42x1/uM=?= <teobaluta@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:49 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
>
>> As far as decoding is concerned, there are a lot of apps on mobile devices
>> that decode QR codes (just text mostly). In order to make this work, an
>> app which also decodes the QR code is needed. I will be working the next
>> couple of weeks on an Android app which scans the Oops encoding QR and
>> sends it to a server which keeps track of these Oopses that are sent to
>> it making a sort of stream of the latest Oopses. Any thoughts on what the best
>> workflow would be are more than welcomed.
>
> When I was thinking about doing this a while ago, my plan was to simply
> encode the oops as a URL - that way existing QR reader software would
> work and there's no need to write a specialised application. I also
> registered the domain kbu.gs to provide the service. Obviously I never
> got around to actually writing the code, so this is great!

That would have worked as well, I guess. I really hope to get this
into shape for it to be accepted.

Thanks.

--
Teodora

>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
