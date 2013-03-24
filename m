Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3CXCRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 22:17:40 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:64663 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab3CXCRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 22:17:37 -0400
MIME-Version: 1.0
In-Reply-To: <514B6D77.8080202@am.sony.com>
References: <514A7E81.9000501@am.sony.com>
	<CACVXFVODZNuoLYSk60YwhFhEv5SX2QkszjjoYDWBHij7zwmhdQ@mail.gmail.com>
	<514B6D77.8080202@am.sony.com>
Date: Sun, 24 Mar 2013 10:17:36 +0800
Message-ID: <CACVXFVNQV8SAP+oKJWJta0WPhjQO6TreU9U8OjHKtZwa6p6_=A@mail.gmail.com>
Subject: Re: [BUG] bisected: PandaBoard smsc95xx ethernet driver error from
 USB timeout
From: Ming Lei <tom.leiming@gmail.com>
To: frank.rowand@am.sony.com
Cc: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "steve.glendinning@smsc.com" <steve.glendinning@smsc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 4:28 AM, Frank Rowand <frank.rowand@am.sony.com> wrote:
>> I play upstream kernel on Pandaboard A1 frequently, looks not
>> see the failure problem before. Maybe the problem is config dependent.
>>
>> If you may share your config file, I'd like to do the test too.

3.9-rc2-20130314 doesn't have the problem observed on my Pandaboard A1,
but I only tested booting from MMC, not from NFS.


Thanks,
-- 
Ming Lei
