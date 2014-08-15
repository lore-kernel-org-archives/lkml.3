Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaHOQcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:32:14 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35248 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaHOQcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:32:11 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: pull request: bluetooth-next 2014-08-14
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140815144545.GL4953@tuxdriver.com>
Date: Fri, 15 Aug 2014 09:32:54 -0700
Cc: "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3B8964A2-1F51-4C62-969A-41F68B5294FA@holtmann.org>
References: <20140814145000.GA14226@t440s.P-661HNU-F1> <20140815144545.GL4953@tuxdriver.com>
To: "John W. Linville" <linville@tuxdriver.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

>> Here's our first bluetooth-next pull request for the 3.18 kernel. Our
>> tree is based on net-next so you'd need to pull from there first before
>> pulling from our tree.
> 
> What did you need from net-next that made you base on that instead
> of wireless-next?  I generally like to decide for myself what level
> of net-next needs to be the base of wireless-next...

mainly the merge conflict resolution for 6lowpan and all the ieee802154 patches before we ended up taking this through bluetooth-next. It just made sense to start out with a clean base tree in this case.

If you prefer, then we can just do that against a new wireless-next tree once you have that ready. I honestly just assumed you are going to pull net-next anyway. So my apologizes for that.

Regards

Marcel

