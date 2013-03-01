Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3CACer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:34:47 -0500
Received: from plane.gmane.org ([80.91.229.3]:35027 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3CACep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:34:45 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: jbian <jbian@redhat.com>
Subject: Re: [PATCH] VMware Balloon: rename module
Date: Fri, 1 Mar 2013 02:19:15 +0000 (UTC)
Message-ID: <loom.20130301T031432-322@post.gmane.org>
References: <AANLkTikWmwVvWzRMK7yvtyqYbd4OeeR1nLsP1OAxbnJg@mail.gmail.com> <201009161623.14722.dtor@vmware.com> <AANLkTinokTUuShVEokYyJApj26CBD-q+xma_55rgdZEM@mail.gmail.com> <201009161731.16913.dtor@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 66.187.233.202 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 CentOS/3.6-2.el5.centos Firefox/3.6.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yeah,the vmware_balloon driver name changed,when the name is vmware_balloon,the
rhel6 guest on esxi5.1,when modprobe the balloon driver,there will be a
process"vmmemctl",after the driver upgrade:vmw_balloon,the rhel7 guest on
esxi5.1,the balloon is vmw_balloon,but the process daemon disappear,but the
balloon still worked well,so why remove the vmmemctl process??

Thanks in advance,I will be feel grateful to receive all your reply.

B.R
jbian



