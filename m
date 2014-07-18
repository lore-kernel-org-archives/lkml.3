Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbaGRQjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:39:44 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51844 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030388AbaGRQji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:39:38 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] [RFC] initial getrandom wrapper to provide getentropy for LibreSSL
From: Brent Cook <busterb@gmail.com>
In-Reply-To: <20140718161936.GA4877@thunk.org>
Date: Fri, 18 Jul 2014 11:33:25 -0500
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <15B9444D-C18A-41AC-BE81-30B43AA3384C@gmail.com>
References: <1405666144-88053-1-git-send-email-busterb@gmail.com> <1158B2FC-1289-4E10-8C99-F407123B0D01@gmail.com> <20140718161936.GA4877@thunk.org>
To: "Theodore Ts'o" <tytso@mit.edu>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 18, 2014, at 11:19 AM, Theodore Ts'o <tytso@mit.edu> wrote:

> On Fri, Jul 18, 2014 at 08:09:52AM -0500, Brent Cook wrote:
>> On Jul 18, 2014, at 1:49 AM, Brent Cook <busterb@gmail.com> wrote:
>> 
>>> From: Brent Cook <bcook@openbsd.org>
>>> 
>>> This is not a kernel patch, but rather an initial test of the API to see
>>> how it might mesh LibreSSL's expectations for how getentropy works.
>>> 
>>> It is a bit more code to carefully handle the extra return values, as
>>> not reading enough bytes, because there is an unhandled EINTR, might
>>> lead to an unseeded CSPRNG.
> 
> Take a look at the latest patch for getrandom.  It contains a
> suggested wrapper which should be sufficient for emulation of
> OpenBSD's getentropy(), and a lot of discussion of when you don't need
> to worry about getting the EINTR.
> 
>   http://lists.openwall.net/linux-kernel/2014/07/18/329
> 
> Again, please don't commit anything until the syscall number and
> interface is finalized.  What is out here is for review, and I already
> have in the git commit a suggested wrapper to provide getentropy(2).
> If you don't think it's good enough, please let me know what your
> concerns might be.  (And yes, I've fixed the obvious missing open
> brace already.  :-)
> 
>   	      	      	  	     	      	    - Ted

Ah, that looks good to me.

I had just stubbed in the placeholder numbers for local testing purposes, no problem holding until it is finalized.

 Thanks!

 - Brent

