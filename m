Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3AQQcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:32:05 -0500
Received: from mail3.vodafone.ie ([213.233.128.45]:20670 "EHLO
	mail3.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3AQQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:31:59 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 11:31:59 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsBABAk+FBtTSm9/2dsb2JhbAANHRqDdYIJR7d2gxEBAQEDASMPAQU6BxALDQsCAgUWCwICCQMCAQIBRRMBBwEBiA8NBSynf3CRRYEjjGyCFoETA5cohHGFLYgE
Message-ID: <50F8252C.2060404@draigBrady.com>
Date: Thu, 17 Jan 2013 16:22:04 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Eric Blake <eblake@redhat.com>
Subject: Re: RFC: allow empty symlink targets
References: <1358427833-3847-1-git-send-email-P@draigBrady.com>
In-Reply-To: <1358427833-3847-1-git-send-email-P@draigBrady.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:03 PM, Pádraig Brady wrote:
> The discussion leading to this is at http://bugs.gnu.org/13447
> In summary other systems allow an empty target for a symlink,
> and POSIX specifies that it should be allowed?

In relation to this, Eric Blake said:

 > In today's Austin Group meeting, I was tasked to open a new bug that
 > would state specifically how the empty symlink is resolved; the intent
 > is to allow both Solaris behavior (current directory) and BSD behavior
 > (ENOENT).  Meanwhile, everyone was in agreement that the Linux kernel
 > has a bug for rejecting the creation of an empty symlink, but once that
 > bug is fixed, then Linux can choose either Solaris or BSD behavior for
 > how to resolve such a symlink.
 >
 > It will probably be a bug report similar to this one, which regarded how
 > to handle a symlink containing just slashes:
 > http://austingroupbugs.net/view.php?id=541

thanks,
Pádraig.
