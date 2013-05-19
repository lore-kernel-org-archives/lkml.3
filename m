Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3ESL0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 07:26:49 -0400
Received: from josephdwagner.info ([72.4.161.242]:39547 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3ESL0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 07:26:48 -0400
Message-ID: <5198B6E7.5000000@josephdwagner.info>
Date: Sun, 19 May 2013 04:26:31 -0700
From: "Joseph D. Wagner" <joe@josephdwagner.info>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kdump fails on encrypted root
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can get kdump to work with encrypted root in kvm, but not on raw iron.

Can anyone help me figure out how to get it working?
