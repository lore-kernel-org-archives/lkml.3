Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab3BMJdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:33:21 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3988 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3BMJdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:33:17 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <511B5DD0.1040103@broadcom.com>
Date: Wed, 13 Feb 2013 10:33:04 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Peter Hurley" <peter@hurleysoftware.com>
cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Maarten Lankhorst" <maarten.lankhorst@canonical.com>,
        "Daniel J Blueman" <daniel@quora.org>,
        "Marcin Slusarz" <marcin.slusarz@gmail.com>,
        "Ben Skeggs" <bskeggs@redhat.com>
Subject: Re: [ 61/61] drm/nouveau: add lockdep annotations
References: <20130212203417.890993903@linuxfoundation.org>
 <20130212203426.021116247@linuxfoundation.org>
 <1360726523.3642.4.camel@thor.lan>
In-Reply-To: <1360726523.3642.4.camel@thor.lan>
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7D0582DE1Z0433017-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 04:35 AM, Peter Hurley wrote:
> On Tue, 2013-02-12 at 12:35 -0800, Greg Kroah-Hartman wrote:
>> 3.7-stable review patch.  If anyone has any objections, please let me know.
> 
> FWIW, I never saw this on 3.7 but it happened 1st time on 3.8-rcX
> I haven't tested this fix either.

Dito.

Gr. AvS


