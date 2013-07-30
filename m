Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3G3TPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:15:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:43747 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3G3TPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:15:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ilari Stenroth <ilari.stenroth@gmail.com>
Subject: arch/x86/kernel/cpu/intel.c needs an update for Haswell?
Date: Tue, 30 Jul 2013 21:50:49 +0300
Message-ID: <kt91u2$jhs$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: gw.stenroth.fi
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does somebody know why arch/x86/kernel/cpu/intel.c has
tlb_flushall_shift detection logic for Ivy Bridge CPU family but not for
Haswell? Maybe intel_cacheinfo.c needs to be checked for Haswell updates
too.

Regards,
Ilari Stenroth

