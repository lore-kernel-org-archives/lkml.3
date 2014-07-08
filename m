Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaGHPyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:54:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33498 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbaGHPyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:54:21 -0400
Date: Tue, 8 Jul 2014 17:54:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        dhowells@redhat.com, pjones@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/9] kexec: Verify signature of PE signed bzImage
Message-ID: <20140708155414.GE27659@pd.tnic>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
 <20140704145118.GD3340@pd.tnic>
 <20140705030134.GA18508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140705030134.GA18508@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 11:01:34PM -0400, Vivek Goyal wrote:
> Given that this time we have a new use case, I am hoping that idea of
> parsing PE and verifying signature is more acceptable.

Maybe.

In any case, I still think that you should post the full patch set and
not refer to some repo so that people can take a look at the whole
thing.

I'll fiddle them out now from David's branch but please add them to your
next submission.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
