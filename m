Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3IVVRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:17:04 -0400
Received: from snt0-omc4-s12.snt0.hotmail.com ([65.55.90.215]:63740 "EHLO
	snt0-omc4-s12.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab3IVVRD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:17:03 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Sep 2013 17:17:03 EDT
X-TMN: [S023wddnjWh7MHhxP6Xv5y695ItArdGw]
X-Originating-Email: [varadgautam@live.com]
Message-ID: <SNT146-W710244DBE31ABDA9A6D398C82C0@phx.gbl>
From: Varad Gautam <varadgautam@live.com>
To: Thiago Farina <tfransosi@gmail.com>,
        linux list <linux-kernel@vger.kernel.org>
Subject: RE: throuble installing kernel
Date: Mon, 23 Sep 2013 02:40:53 +0530
Importance: Normal
In-Reply-To: <CACnwZYfz_3AJc+cL4rBP1rhGWAmk+V18C3EOJtuVx2eRjtb9LA@mail.gmail.com>
References: <CACnwZYfz_3AJc+cL4rBP1rhGWAmk+V18C3EOJtuVx2eRjtb9LA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Sep 2013 21:10:54.0165 (UTC) FILETIME=[39403050:01CEB7D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I'm doing wrong? I want it to use my .config, I don't want to
> answer all the thousands questions it prompts me (I don't know all the
> options to know what should go and what should not, hence I want it to
> use my current configuration).

Hi! If you want to use the existing .config file, you should use `make oldconfig` instead. It may still prompt for options not in the file; to use the default ones, just do `yes "" | make oldconfig`. 		 	   		  