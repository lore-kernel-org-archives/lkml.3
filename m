Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab3DGRrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 13:47:14 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:55357 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144Ab3DGRrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 13:47:13 -0400
Date: Sun, 7 Apr 2013 10:43:13 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Bryan Freed <bfreed@chromium.org>, Tony Luck <tony.luck@intel.com>,
        keescook@chromium.org, marco.stornelli@gmail.com,
        gregkh@linuxfoundation.org,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        sboyd@codeaurora.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v6] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
Message-ID: <20130407174313.GA7168@lizard>
References: <1347042576-17675-1-git-send-email-bfreed@chromium.org>
 <20120908052907.GA4724@lizard>
 <20120917062302.GA768@lizard>
 <CAL_JsqK_L9nN6+oxUQzNwFjbFf3+3NroeEwzbMdPS4T6=Mnemg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_JsqK_L9nN6+oxUQzNwFjbFf3+3NroeEwzbMdPS4T6=Mnemg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 09:03:47PM -0500, Rob Herring wrote:
> On Mon, Sep 17, 2012 at 1:23 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > On Fri, Sep 07, 2012 at 10:29:10PM -0700, Anton Vorontsov wrote:
> >> On Fri, Sep 07, 2012 at 11:29:36AM -0700, Bryan Freed wrote:
> >> > When called with a non-zero of_node, fill out a new ramoops_platform_data
> >> > with data from the specified Flattened Device Tree node.
> >> > Update ramoops documentation with the new FDT interface.
> >> > Update devicetree/binding documentation with pstore/ramoops.txt.
> >>
> >> Thanks for your work, Bryan! There were a few issues, I fixed
> >> them myself but I need your confirmation if you're OK w/ all
> >> the changes.
> > [...]
> >> So, the resulting patch is down below. But I have not pushed
> >> it out yet, I'm waiting for your sign off. If you're OK with the
> >> changes, please reply with
> >> 'Signed-off-by: Bryan Freed <bfreed@chromium.org>'
> >
> > Bryan, have you had a chance to look into this?
> 
> Whatever happened to this? Olof was also looking at doing a binding
> back in Jan 2012:
> 
> http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg09905.html

I don't know. Bryan's patch looked good, I'd happily apply it. But I still
need Bryan's Signed-off-by tag. :-/ Or, somebody needs to sign off on his
behalf (anyone from Chromium project?). Or redo the patch.

Thanks,

Anton
