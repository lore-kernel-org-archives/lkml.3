Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818Ab3BYUzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:55:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48152 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729Ab3BYUyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:54:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        x86@kernel.org
Subject: [PATCH] Documentation and source code comments updates (v1)
Date: Mon, 25 Feb 2013 15:54:07 -0500
Message-Id: <1361825650-14031-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Three little patches to update the Documentation/kernel-parameters and
also some of the complex x86 trampoline code.

Nothing serious, just a little cleanup.

