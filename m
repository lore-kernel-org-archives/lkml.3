Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaDTTS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 15:18:27 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:48196 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaDTTSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 15:18:23 -0400
Date: Sun, 20 Apr 2014 14:08:02 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <53541b1214393_1f08dd12ece5@nysa.notmuch>
In-Reply-To: <xmqqk3ambf9k.fsf@gitster.dls.corp.google.com>
References: <xmqqk3ambf9k.fsf@gitster.dls.corp.google.com>
Subject: RE: [ANNOUNCE] Git v2.0.0-rc0
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
>  * transport-helper, fast-import and fast-export have been updated to
>    allow the ref mapping and ref deletion in a way similar to the
>    natively supported transports.

Have they?

% git --version
git version 2.0.0.rc0
% git push origin origin master:foo                                                                                /tmp/test[master] nysa
searching for changes
no changes found
fatal: remote-helpers do not support old:new syntax
ERROR: unhandled export command:

I think you are missing the patches which I just resent[1].

[1] http://article.gmane.org/gmane.comp.version-control.git/246558

-- 
Felipe Contreras
