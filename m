Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3ETCT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:19:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab3ETCT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:19:59 -0400
Date: Sun, 19 May 2013 19:20:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Consult] Why need we call device_remove_file() firstly before
 call device_unregister() ?
Message-ID: <20130520022016.GA2945@kroah.com>
References: <5195C39F.9010101@asianux.com>
 <CACVXFVNiWwiXtubJSbE3z6-AyxcOBgyvhn+2diHyi5Nyj4XYeg@mail.gmail.com>
 <5199765F.5000905@asianux.com>
 <20130520014506.GA2201@kroah.com>
 <51998699.4080202@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51998699.4080202@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:12:41AM +0800, Chen Gang wrote:
> I mean that if no reply by any other members within a week, I will know
> it is correct that "we need not call device_remove_file() firstly before
> call device_unregister()" (at least, one member's reply supports this
> conclusion).
> 
> I find this 'question' when discussing a patch with another members in
> linux-kernel@vger.kernel.org, I have read the related code and also have
> searched with google, but can not find the result, so I want to consult
> it in linux-kernel@vger.kernel.org.

Asking random questions on lkml, and relying on the fact that no one
else happens to say anything, is not any judge as to if the answer is
correct at all.

In fact, just asking questions on lkml has a very low chance of ever
getting a correct answer, given that the people that usually do know the
answer to these types of things are usually:
  1) not reading lkml because they are busy doing real work
  2) annoyed by questions that are easily answered by themselves by
     either:
       a) reading the code
       b) writing a simple example module and testing it out yourself


Good luck,

greg k-h
