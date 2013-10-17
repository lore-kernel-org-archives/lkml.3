Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab3JQAFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:05:52 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:46550 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3JQAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <20131016235730.GK7082@xanatos>
References: <1381872227-24757-1-git-send-email-jwerner@chromium.org>
	<525DB456.1040006@cogentembedded.com>
	<CAODwPW-wKtN9JhoJCs+LoBx4Pj65+pozKv=ycLQJfsL1k28zEQ@mail.gmail.com>
	<1381884300-403-1-git-send-email-jwerner@chromium.org>
	<20131016235730.GK7082@xanatos>
Date: Wed, 16 Oct 2013 17:05:49 -0700
X-Google-Sender-Auth: aMgx_39GOrDrmKGSoB70T7kBfdU
Message-ID: <CANLzEkvy_N1wtjZgOCvqQX6AS3cPZH458XeGwRxGff5oWk91RA@mail.gmail.com>
Subject: Re: [PATCH v2] usb: hub: Clear Port Reset Change during init/resume
From: Benson Leung <bleung@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Vincent Palatin <vpalatin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 4:57 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
>
> Did you run into an issue where port status change events weren't being
> generated because the Port Reset flag was set?  I'm trying to figure out
> if this addresses a real issue you hit (and thus should be queued for
> stable), or if this is just a precaution.

We ran into this on HP Chromebook 14 (Falco). The port reset flag
would be set after a suspend/resume cycle with nothing attached.


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
