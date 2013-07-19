Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416Ab3GSG3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 02:29:15 -0400
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:51909 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546Ab3GSG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 02:29:12 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jul 2013 02:29:12 EDT
X-MXL-Hash: 51e8dcb879ffb4bb-4d306b5a2bd221af63fe06abc7ef285077207fdd
X-MXL-Hash: 51e8daf244a33fdc-11447df69a5449ae80cb6635c3c7f4fb2b0e04ac
Date: Thu, 18 Jul 2013 23:21:36 -0700
From: Amit Uttamchandani <auttamchandani@logicube.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/velocity: add poll controller function for
 velocity nic
Message-ID: <20130719062136.GA30777@amit-debian.lg.local>
References: <1374194722-6051-1-git-send-email-auttamchandani@logicube.com>
 <20130719061107.GB3334@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719061107.GB3334@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 19 Jul 2013 06:19:47.0765 (UTC) FILETIME=[F7F13E50:01CE8447]
X-AnalysisOut: [v=2.0 cv=HaijuF48 c=1 sm=1 a=0uUgrnGYR7mgTYOISY3a5A==:17 a]
X-AnalysisOut: [=wom5GMh1gUkA:10 a=5PW2zfKtIYcA:10 a=odQdQWa4cxwA:10 a=BLc]
X-AnalysisOut: [eEmwcHowA:10 a=kj9zAlcOel0A:10 a=zinYphYSAAAA:8 a=rUYqSnz4]
X-AnalysisOut: [T3kA:10 a=BZ86JS3Di3ngp8NBC8cA:9 a=CjuIK1q_8ugA:10 a=ZaEPc]
X-AnalysisOut: [xSHRvoA:10 a=OBXKdzq5da8A:10 a=U7nmRrEOfrkA:10]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010122901)]
X-MAIL-FROM: <auttamchandani@logicube.com>
X-SOURCE-IP: [209.239.228.35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 08:11:07AM +0200, Francois Romieu wrote:
> Amit Uttamchandani <auttamchandani@logicube.com> :
> > Add poll controller function for velocity nic.
> 
> Thanks.
> 
> You did not state if it was tested. Was it ?
> 

Yes, tested with latest upstream kernel and latest -stable 3.2.y (3.2.48).

Thanks.

