Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaHOBaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 21:30:22 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51394 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaHOBaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 21:30:20 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: pull request: bluetooth-next 2014-08-14
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140815095547.75d9e9d4@canb.auug.org.au>
Date: Thu, 14 Aug 2014 18:30:54 -0700
Cc: Johan Hedberg <johan.hedberg@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <027436B7-E5DF-4AFB-B43C-65AB41D0200D@holtmann.org>
References: <20140814145000.GA14226@t440s.P-661HNU-F1> <20140815095547.75d9e9d4@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

>> Here's our first bluetooth-next pull request for the 3.18 kernel. Our
>> tree is based on net-next so you'd need to pull from there first before
>> pulling from our tree.
> 
> This is in a branch that will be included in linux-next today.  I guess
> you didn't read my (very often) repeated request that no v3.18 material
> be included until after v3.17-rc1 is released ... Please do not do that.

to be honest I did not know about this rule. Next time, I will create a special tree for the time during the merge window so that we can continue pushing out patches for the next release. For us the world is not standing still just because we have a 2 week merge window.

Regards

Marcel

