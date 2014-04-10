Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935761AbaDJUBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:01:40 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46335 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070AbaDJUBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:01:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140410195402.GA17308@kroah.com>
References: <20140410203146.767149e7@spike>
	<CAJUuVQ5KW3v0DgwotDMow=rBvxoZKfYYD2misXbsMD6c1UaShw@mail.gmail.com>
	<20140410195402.GA17308@kroah.com>
Date: Thu, 10 Apr 2014 16:01:35 -0400
Message-ID: <CAJUuVQ7xgRLDzwojDCdb3yhTm3HygypMLXyaRiErnVveNVz+sQ@mail.gmail.com>
Subject: Re: [PATCH resend] rsi: Fix a potential memory leak in rsi_set_channel()
From: Andev <debiandev@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, linville@tuxdriver.com,
        fariyaf@gmail.com, dan.carpenter@oracle.com, joe@perches.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 3:54 PM, Greg Kroah-Hartman <greg@kroah.com> wrote:
> On Thu, Apr 10, 2014 at 03:46:12PM -0400, Andev wrote:
>> Adding Greg KH,
>
> Why do I care about this?
>

I am not sure if this needs to be applied to stable too. Should I have
cc'ed stable@?

-- 
Pratapa Rudra
