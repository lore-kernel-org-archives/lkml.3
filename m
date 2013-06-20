Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3FTFV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:21:28 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49358 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3FTFV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:21:26 -0400
Date: Thu, 20 Jun 2013 00:21:21 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 7/7] KVM: MMU: document fast invalidate all mmio sptes
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<1371632965-20077-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1371632965-20077-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	(from xiaoguangrong@linux.vnet.ibm.com on Wed Jun 19 04:09:25 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1371705681.2776.131@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 04:09:25 AM, Xiao Guangrong wrote:
> Document it to Documentation/virtual/kvm/mmu.txt

Why break a change to a single documentation file into 7 pieces.

Are we going to bisect the documentation?

Rob