Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3AXNuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:50:40 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36350 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3AXNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:50:33 -0500
Date: Thu, 24 Jan 2013 22:50:22 +0900 (JST)
Message-Id: <20130124.225022.525573019471019215.kou1.ono@gmail.com>
To: pebolle@tiscali.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: linux-3.7.4: BUG: unable to handle kernel NULL pointer
 dereference at target_fabric_port_link
From: Kouichi ONO <kou1.ono@gmail.com>
In-Reply-To: <1359021353.1325.1.camel@x61.thuisdomein>
References: <20130124.010724.710820132553071688.kou1.ono@gmail.com>
	<1359021353.1325.1.camel@x61.thuisdomein>
X-Mailer: xcite1.60> Mew version 6.5rc2 on Emacs 24.2 / Mule 6.0
 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> On Thu, 2013-01-24 at 01:07 +0900, Kouichi ONO wrote:
> > At target_fabric_port_link(), struct se_device *dev is used before set?
> 
> It seems the (stable specific) patch in
> http://article.gmane.org/gmane.linux.kernel.stable/40880 should fix
> that.

This patch fixed a problem.

Thanks a lot!

 Kouichi ONO
