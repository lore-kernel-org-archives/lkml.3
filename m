Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaFNNJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:09:31 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57131 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaFNNJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:09:29 -0400
Date: Sat, 14 Jun 2014 09:09:25 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: tidspbridge: Fix function pointer spacing
 in struct definition
Message-ID: <20140614130925.GA14744@fofx>
References: <1402714093-15404-1-git-send-email-jeffoczek@gmail.com>
 <1402714093-15404-2-git-send-email-jeffoczek@gmail.com>
 <1402716700.2756.3.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402716700.2756.3.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 08:31:40PM -0700, Joe Perches wrote:
> On Fri, 2014-06-13 at 22:48 -0400, Jeff Oczek wrote:
> > -	 s32(*fread) (void *, size_t, size_t, void *);
> > -	 s32(*fseek) (void *, long, int);
> > -	 s32(*ftell) (void *);
> > -	 s32(*fclose) (void *);
> > -	void *(*fopen) (const char *, const char *);
> > +	 s32 (*fread)(void *, size_t, size_t, void *);
> > +	 s32 (*fseek)(void *, long, int);
> > +	 s32 (*ftell)(void *);
> > +	 s32 (*fclose)(void *);
> > +	void *(*fopen)(const char *, const char *);
> 
> Better would be to describe the arguments with
> variable names and align all the return values
> 
> 	void *(*fopen
> 
> 	s32 (*fread)(void *arg1, size_t val1, size_t val2, void *ptr1);
> 	s32 (*fseek)(void *ptr1, long arg2, int arg3);
> 	s32 (*ftell)(void * ptr);
> 	s32 (*fclose)(void *ptr);
> 	void *(*fopen)(const char *ptr1, const char *ptr2);
> 
> where arg, val, ptr are actually useful descriptors
> 

Thanks Joe.  I was just trying to stay in the scope of making a
really trivial coding style change for the sake of following the
submission process for the first time.  But I'll resend based on
your suggestion.
