Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab3GOOvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:51:25 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:62912 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3GOOvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:51:23 -0400
Message-ID: <51e40c69.e8c6ec0a.14aa.fffff47c@mx.google.com>
Date: Mon, 15 Jul 2013 11:51:18 -0300
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
Subject: Re: 3.10.0: Full dynticks = high load
In-Reply-To: <20130715142556.GA6442@somewhere>
References: <krlv29$jbp$1@ger.gmane.org>
	<20130712065227.GC1985@fancy-poultry.org>
	<ks0s36$ntc$1@ger.gmane.org>
	<1373895406.7353.99.camel@marge.simpson.net>
	<20130715142556.GA6442@somewhere>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.9.0cvs128 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013 16:25:59 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> Sorry I'm missing the description of the issue. Could you please
> repaste it?
> 
> Thanks!

	The problem is that when we use the new Full dynticks option
form kernel 3.10.0, the load will go high, always above 1. Bug?

-- 
Linux 3.10.0: Unicycling Gorilla
http://www.youtube.com/DanielFragaBR
http://www.libertarios.org.br
