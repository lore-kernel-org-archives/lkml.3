Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3GXWFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:05:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3GXWFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/36] remove dev_attrs usage in 'struct class'
Date: Wed, 24 Jul 2013 15:05:03 -0700
Message-Id: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are a bunch of patches working to convert drivers to use the
dev_groups field in classes instead of using the dev_attrs field, which
will be going away soon, as we really only want to support groups in the
future, not multiple ways of creating default attributes.

They are all CC:ed the various driver authors, and can go in through
their trees, or through mine, which ever is easier.

thanks,

greg k-h

