Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3AWOsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:48:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3AWOsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:48:12 -0500
Date: Wed, 23 Jan 2013 15:48:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Greg KH <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [RFC] Add a "Co-authored-by" commit tag
Message-ID: <Pine.LNX.4.64.1301231528020.26301@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:mxrLmNCk+l0NH5cJIl/ocDpn2PfRuC34dJ0mJ21dm1U
 GWku0bdTtIcaF3YTbBpFaBY3GNy3nbzOzh/1ggupAq+gw9BFoK
 2fF/W/VafP3qOOyvgo/9vqbYY46BRqYe5BMQmz/HBOjDgLeDZ3
 TKMcyD2VtvJ8eqMrkfiNBAzapoPdgg+9blOIFOh1T4LoT7c5Aq
 fioheuZPSxJmf63Kbf9zu3IwDGy/oBbSYIZUqVz46GJPqFmpYH
 CDvsfzZ19I0BmWArWsrPoaiK67/xh8fh5b9YnKt/y72iHHcup3
 fwJ8ojSWk456UdARuuJGKqm1nP0R+Aw7IiNog7WKqSuGFBcZIj
 fm9CU33z5SLa9C15Z/xXW9FAsUQiBOaTKaMCBpBjG+psWRduFn
 NON+IaPU4LQag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

In most cases we work on our patches from the beginning to the end, but 
from time to time it happens, that someone originates a patch but then 
becomes (temporarily) unable to continue with new reviews, so, someone 
picks it up from there and brings to a final form. Or simply even several 
persons work closely on one patch. A yet another case is, when someone 
posts a rough first version of a patch, but then someone else heavily 
reworks it and becomes the actual submitting author of the patch, still, 
the original author should be mentioned somehow too.

Currently we can do something like

From: Original Author <...>

Signed-off-by: Original Author <...>
[contributor-2@...: continued patch development since v2]
Signed-off-by: New Contributor <contributor-2@...>

But is this sufficient, wouldn't a "Co-authored-by" tag be a better match 
for similar situations?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
