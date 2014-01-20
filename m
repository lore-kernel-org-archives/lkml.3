Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaATNBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:01:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaATNBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:01:51 -0500
Date: Mon, 20 Jan 2014 16:01:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        oleg.drokin@intel.com, jacques-charles.lafoucriere@cea.fr,
        jinshan.xiong@intel.com, linux-metag@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add
 "__attribute__((packed))" for the related union
Message-ID: <20140120130116.GW7444@mwanda>
References: <52DA4E6A.1000308@gmail.com>
 <20140118100547.GS7444@mwanda>
 <52DA56C2.5010802@gmail.com>
 <20140118142404.GT7444@mwanda>
 <52DBA3D4.3090308@gmail.com>
 <52DD0EFF.2010305@imgtec.com>
 <20140120123045.GV7444@mwanda>
 <52DD18A5.1090308@imgtec.com>
 <20140120125603.GD4815@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120125603.GD4815@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you sure it's padding the unions, and not just treating the unions
as structs?  What is the size of this union?

union a {
	int x;
	short y;
};

regards,
dan carpenter
