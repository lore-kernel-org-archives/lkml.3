Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3GONGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:06:00 -0400
Received: from plane.gmane.org ([80.91.229.3]:52575 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab3GONF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:05:59 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: 3.10.0: Full dynticks = high load
Date: Mon, 15 Jul 2013 10:05:49 -0300
Organization: http://www.youtube.com/DanielFragaBR
Message-ID: <ks0s36$ntc$1@ger.gmane.org>
References: <krlv29$jbp$1@ger.gmane.org>
	<20130712065227.GC1985@fancy-poultry.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 177.102.3.30
X-Newsreader: Claws Mail 3.9.0cvs128 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013 08:52:27 +0200
Heinz Diehl <htd@fancy-poultry.org> wrote:

> This describes exactly what I have encountered, and "tickless idle"
> fixed it for me, too. So I'll second that.

	Thanks for the confirmation. I hope Ingo Molnar fixes it.

-- 
Linux 3.10.0: Unicycling Gorilla
http://www.youtube.com/DanielFragaBR
http://www.libertarios.org.br


