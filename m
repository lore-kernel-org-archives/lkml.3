Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3C0V3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:29:45 -0400
Received: from plane.gmane.org ([80.91.229.3]:51909 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab3C0V3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:29:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Viktor Ostashevskyi <ostash@ostash.kiev.ua>
Subject: Re: [PATCH v2] perf: add callgrind conversion tool
Date: Wed, 27 Mar 2013 21:26:47 +0000 (UTC)
Message-ID: <loom.20130327T222035-128@post.gmane.org>
References: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 89.76.196.222 (Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.160 Safari/537.22)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roberto,

Roberto Vitillo <ravitillo <at> lbl.gov> writes:

> The proposed patch adds the convert tool to perf which allows to convert a
> perf.data file to a set of callgrind data files which can subsequently be
> displayed with kcachegrind.


Incredible job! Absence of this feature forced me to write my own converter,
perfgrind (https://github.com/ostash/perfgrind).

BTW, you can get a2l functionality from elfutils as well, so there will be no 
dependency on libbfd.



