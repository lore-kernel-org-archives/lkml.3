Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaJ1ONI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:13:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaJ1ONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:13:07 -0400
Date: Tue, 28 Oct 2014 22:11:54 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 09/11] drivers: char: axd: add sysfs setup files
Message-ID: <20141028141154.GB18384@kroah.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <1414495589-8579-10-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414495589-8579-10-git-send-email-qais.yousef@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:26:27AM +0000, Qais Yousef wrote:
> lots of AXD configuration is exposed through sysfs, these
> files create all the necessary nodes to allow setting up AXD

Yet you don't document that interface through the required
Documentation/ABI/ files?  Why not?

