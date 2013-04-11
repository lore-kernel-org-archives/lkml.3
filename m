Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3DKQTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:19:39 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53532 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3DKQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:19:38 -0400
Date: Thu, 11 Apr 2013 09:19:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130411161936.GA390@kroah.com>
References: <20130406165600.GA29660@kroah.com>
 <87y5cpvhaz.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5cpvhaz.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 09:10:12PM -0700, Eric W. Biederman wrote:
> Still it approaches being twisted to have files like
> /sys/class/net/eth0/uevent that anyone can read that will only return
> values in the initial user namespace.

Side note, I don't think that ethernet network devices have uids :)
