Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaIYTNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:13:00 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65201 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaIYTM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:12:58 -0400
Date: Thu, 25 Sep 2014 21:12:54 +0200
From: Frans Klaver <fransklaver@gmail.com>
To: Oscar Utbult <oscar@oscr.io>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Changed "&" with "and" in
 Documentation/applying-patches.txt.
Message-ID: <20140925191254.GA2073@gmail.com>
References: <1411652495-100852-1-git-send-email-oscar@oscr.io>
 <CAH6sp9NqiNincavwB9bQ94EvG8ZjvUPLH5u3j04OV2JMz7wTEg@mail.gmail.com>
 <e692e73445c591af1bea3ce0a87755c6@oscr.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e692e73445c591af1bea3ce0a87755c6@oscr.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 06:28:47PM +0200, Oscar Utbult wrote:
> On 2014-09-25 16:48, Frans Klaver wrote:
> > On Thu, Sep 25, 2014 at 3:41 PM,  <oscar@oscr.io> wrote:
> >> Subject: [PATCH 1/1] Changed "&" with "and" in 
> >> Documentation/applying-patches.txt.
> > 
> > Documentation/SubmittingPatches says:
> > 
> > Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
> > instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
> > to do frotz", as if you are giving orders to the codebase to change
> > its behaviour.
> 
> Thank you for your feedback Frans.
> 
> So for example a better description would have been: "use 'and' instead 
> of '&'"?

Yes. It is useful to still mention it is affecting documentation only
though. This helps identifying whether a change may be related to a
defect for example.

By the way, I just grepped through the documentation, and there are
quite some situations where this same change would happen, so if we care
enough, all those instances could be changed. I don't know if we care
enough though. That's for others, like Randy, to decide.

Frans
