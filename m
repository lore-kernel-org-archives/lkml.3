Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751AbaDJTve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:51:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57250 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935718AbaDJTva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:51:30 -0400
X-Sasl-enc: pU3RxqROq2pDleibHo/QZk7cs7G8IfsbZ3LZR4fZb8NQ 1397159489
Date: Thu, 10 Apr 2014 12:54:02 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Andev <debiandev@gmail.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, linville@tuxdriver.com,
        fariyaf@gmail.com, dan.carpenter@oracle.com, joe@perches.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] rsi: Fix a potential memory leak in
 rsi_set_channel()
Message-ID: <20140410195402.GA17308@kroah.com>
References: <20140410203146.767149e7@spike>
 <CAJUuVQ5KW3v0DgwotDMow=rBvxoZKfYYD2misXbsMD6c1UaShw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJUuVQ5KW3v0DgwotDMow=rBvxoZKfYYD2misXbsMD6c1UaShw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 03:46:12PM -0400, Andev wrote:
> Adding Greg KH,

Why do I care about this?

