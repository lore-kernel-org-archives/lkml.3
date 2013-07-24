Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3GXG2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab3GXG2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:28:06 -0400
Message-ID: <51EF73EF.1040305@redhat.com>
Date: Tue, 23 Jul 2013 23:27:59 -0700
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Ritesh Raj Sarraf <rrs@debian.org>,
        targetcli-fb-devel@lists.fedorahosted.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: targetcli -fb now also Apache 2.0 licensed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

I just wanted to let you know that I finally received permission from 
all contributors, and have matched RisingTide's relicensing of targetcli 
and its dependencies to Apache 2.0, by relicensing the additional 
contributions in the targetcli-fb branch under the same license.

I'm not quite sure the next steps are, except enjoying all our newly 
non-viral source code, but much thanks for getting the ball rolling.

Regards -- Andy

p.s. targetcli is the userspace tool to easily configure the 'LIO' 
kernel target, in case any readers were wondering.
