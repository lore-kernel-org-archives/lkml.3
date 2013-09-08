Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab3IHMDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:03:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:32788 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3IHMDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:03:14 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH v2 09/15] KVM: MMU: introduce pte-list lockless walker
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <1378376958-27252-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Date: Sun, 8 Sep 2013 20:03:07 +0800
Cc: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <968DDBF5-4B2D-44A9-89D3-4D233AC51035@gmail.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1378376958-27252-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 5, 2013, at 6:29 PM, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> 
> A desc only has 3 entries
> in the current code so it is not a problem now, but the issue will
> be triggered if we expend the size of desc in the further development

Sorry, this description is obvious wrong, the bug exists even if 3 entries in the desc… 
do not know what i was thinking about when wrote this down...