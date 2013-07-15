Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab3GOSuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:50:55 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:62329 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3GOSuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:50:54 -0400
Message-ID: <51e4448c.6297ec0a.6301.5e14@mx.google.com>
Date: Mon, 15 Jul 2013 15:50:49 -0300
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
Subject: Re: 3.10.0: Full dynticks = high load
In-Reply-To: <20130715150134.GB6442@somewhere>
References: <krlv29$jbp$1@ger.gmane.org>
	<20130712065227.GC1985@fancy-poultry.org>
	<ks0s36$ntc$1@ger.gmane.org>
	<1373895406.7353.99.camel@marge.simpson.net>
	<20130715142556.GA6442@somewhere>
	<51e40c69.e8c6ec0a.14aa.fffff47c@mx.google.com>
	<20130715150134.GB6442@somewhere>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.9.0cvs128 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013 17:01:35 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Jul 15, 2013 at 11:51:18AM -0300, Dâniel Fraga wrote:
> > 	The problem is that when we use the new Full dynticks option
> > form kernel 3.10.0, the load will go high, always above 1. Bug?
> 
> You mean this is the result that the "uptime" command gives you? And
> your system is doing something? Or is it mostly idle?

	It is idle, but the load remains high all the time. Going back
to the "Idle dynticks system (tickless idle)" solves the problem.

	So the issue is with the new Full dynticks.

-- 
Linux 3.10.0: Unicycling Gorilla
http://www.youtube.com/DanielFragaBR
http://www.libertarios.org.br
