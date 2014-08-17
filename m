Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaHQQtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:49:39 -0400
Received: from linuxhacker.ru ([217.76.32.60]:56323 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaHQQti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:49:38 -0400
Subject: Re: [PATCH 10/10] lustre: Add some basic documentation
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140817163758.GB15982@kroah.com>
Date: Sun, 17 Aug 2014 12:49:30 -0400
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Transfer-Encoding: 8BIT
Message-Id: <73475176-52A2-4030-88D6-DBDED4A83E0F@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru> <1408121295-29115-11-git-send-email-green@linuxhacker.ru> <20140817163758.GB15982@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 17, 2014, at 12:37 PM, Greg Kroah-Hartman wrote:

> On Fri, Aug 15, 2014 at 12:48:15PM -0400, Oleg Drokin wrote:
>> This adds Documentation/filesystems/lustre.txt with some
>> basic information about Lustre and how to use it.
>> 
>> Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
>> ---
>> Documentation/filesystems/lustre.txt | 87 ++++++++++++++++++++++++++++++++++++
> 
> No, don't break out of drivers/staging/lustre/ just yet please.

Sure, should I just add this somewhere inside drivers/staging/lustre so that it's not lost
and people have some starting info?