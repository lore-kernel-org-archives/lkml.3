Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaCNPcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:32:12 -0400
Received: from 124-84-246-161.wendulka.net ([84.246.161.124]:53773 "EHLO
	ixit.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753707AbaCNPcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:32:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2014 17:32:38 +0100
From: David Heidelberger <david.heidelberger@ixit.cz>
To: linux-kernel@vger.kernel.org
Subject: [0/4] uapi header fixes for musl libc
Message-ID: <7b680194b69a7b1393005a52a1d372eb@ixit.cz>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series enables support for the uapi headers to cooperate with 
musl libc.
