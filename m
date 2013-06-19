Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3FSPZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:25:36 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:39620 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962Ab3FSPZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:25:34 -0400
Date: Wed, 19 Jun 2013 17:25:28 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: dan.carpenter@oracle.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] FMC: NULL dereference on allocation failure
Message-ID: <20130619152528.GA16430@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20130619144904.GA10484@elgon.mountain>
References: <20130619144904.GA10484@elgon.mountain> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we don't allocate "arr" then the cleanup path will dereference it and
> oops.

You are right, thanks (acked).

How is the procedure here? I don't have my own git tree on
kernel.org for pull requests. Can this go through the janitors?

(if it makes sense, I can try the procedure to have a tree, but last
time I checked it was strictly denied to anyone).

thanks
/alessandro
