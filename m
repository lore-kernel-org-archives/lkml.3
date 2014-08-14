Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaHNS3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:29:05 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47923 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaHNS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:29:03 -0400
Date: Thu, 14 Aug 2014 11:28:58 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: network interfaces called "all", "default" or "config"
Message-ID: <20140814112858.35a0cc88@haswell.linuxnetplumber.net>
In-Reply-To: <CACsCDOP8DOnB0zZtT_WLhiBXjxXh1aH1eGF9_h0dRN1i9YDU-A@mail.gmail.com>
References: <20140723113314.GA7798@chaz.gmail.com>
	<53CFCD26.1020409@infradead.org>
	<CACsCDOP8DOnB0zZtT_WLhiBXjxXh1aH1eGF9_h0dRN1i9YDU-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014 10:41:39 +0100
Stephane Chazelas <stephane.chazelas@gmail.com> wrote:

> $ ip link add link eth0 eth0:123 type vlan id 123
> $ ip link del link eth0 eth0:123
> RTNETLINK answers: Operation not supported

eth0:123 is one of the old style interface names.
Kernel and iproute treat these specially.
Don't use them. They exist only for compatibility with the
dark ages.

You should use period (ie eth0.123) for VLAN's
