Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3A3T0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:26:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3A3T0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:26:20 -0500
Message-ID: <510973C8.1090209@oracle.com>
Date: Wed, 30 Jan 2013 13:26:00 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V6 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com> <x49obg7omos.fsf@segfault.boston.devel.redhat.com> <510891ED.8090404@oracle.com> <x49d2wmqxui.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49d2wmqxui.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, I have updated the patchset in git. I removed the version
from the name of the branch and will keep this one updated:

git://github.com/kleikamp/linux-shaggy.git aio_loop
